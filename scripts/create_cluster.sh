#!/bin/bash
set -e

CONTROL_PLANE_URL="$1"
API_KEY="$2"
CLUSTER_NAME="$3"
CLUSTER_TYPE="$4"
PROVIDER_CONFIG_BASE64="$5"

# Generic function to make HTTP requests
# Parameters:
# $1 - HTTP method (GET, POST, PUT, etc.)
# $2 - URL
# $3 - Request body (optional)
# $4 - Expected status codes (comma-separated list, e.g., "200,201")
make_request() {
    local method="$1"
    local url="$2"
    local body="$3"
    local expected_status_codes="$4"
    local response_file=$(mktemp)
    local http_code_file=$(mktemp)
    
    echo "Making ${method} request to ${url}" >&2
    
    # Build curl command
    local curl_cmd="curl -s -X ${method} \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -H 'Authorization: Bearer ${API_KEY}'"

    # Add request body if provided
    if [ -n "$body" ]; then
        curl_cmd="$curl_cmd -d '${body}'"
        echo "Request body: ${curl_cmd} $url" >&2
    fi
    
    # Make the request
    eval "${curl_cmd} '${url}'" > "${response_file}" 2>/dev/null
    local curl_exit_code=$?
    
    # Get HTTP status code in a separate curl call
    eval "${curl_cmd} -o /dev/null -w '%{http_code}' '${url}'" > "${http_code_file}" 2>/dev/null
    local http_code=$(<"${http_code_file}")
    
    # Clean up temp files
    rm -f "${http_code_file}"
    
    # Check if curl failed
    if [ $curl_exit_code -ne 0 ]; then
        echo "Curl command failed with exit code: ${curl_exit_code}" >&2
        rm -f "${response_file}"
        return 1
    fi
    
    # Check if status code is in expected list
    if [[ ! ",$expected_status_codes," =~ ,"${http_code}", ]]; then
        echo "Request failed with status code: ${http_code}" >&2
        echo "Response body:" >&2
        cat "${response_file}" >&2
        rm -f "${response_file}"
        return 1
    fi
    
    # Return response body only
    cat "${response_file}"
    rm -f "${response_file}"
    return 0
}

# Function to handle errors
handle_error() {
    local message="$1"
    echo "Error: ${message}" >&2
    exit 1
}

# Check platform health
echo "Checking platform health..."
health_check=$(make_request "GET" "${CONTROL_PLANE_URL}/api/svc/" "" "200") || \
    handle_error "Platform health check failed"

# Get environment names
echo "Getting environment names..."
env_response=$(make_request "GET" "${CONTROL_PLANE_URL}/api/svc/v1/environment/" "" "200,201") || \
    handle_error "Failed to get environment names"

# Parse the environment response
environment_name=$(echo "${env_response}" | jq -r '.[0].name') || \
    handle_error "Failed to parse environment response"

if [ -z "${environment_name}" ] || [ "${environment_name}" = "null" ]; then
    handle_error "No environment name found in response"
fi

echo "Found environment: ${environment_name}"

# Generate cluster manifest
cluster_manifest=$(cat <<EOF
{
  "manifest": {
    "name": "${CLUSTER_NAME}",
    "type": "cluster",
    "monitoring": {
      "loki_url": "http://loki.loki.svc.cluster.local:3100",
      "prometheus_url": "http://prometheus-operated.prometheus.svc.cluster.local:9090"
    },
    "collaborators": [
      {
        "role_id": "cluster-admin",
        "subject": "user:tfy-user@truefoundry.com"
      }
    ],
    "cluster_type": "${CLUSTER_TYPE}",
    "environment_names": ["${environment_name}"]
  }
}
EOF
)

# Function to get cluster token
get_cluster_token() {
    local cluster_id="$1"
    echo "Getting cluster token..."
    
    local token_response=$(make_request "GET" \
        "${CONTROL_PLANE_URL}/api/svc/v1/cluster/${cluster_id}/token" \
        "" "200") || handle_error "Failed to get cluster token"
    
    local cluster_token=$(echo "${token_response}" | jq -r '.clusterToken') || \
        handle_error "Failed to parse cluster token response"
    
    if [ -z "${cluster_token}" ] || [ "${cluster_token}" = "null" ]; then
        handle_error "No cluster token found in response"
    fi
    
    echo "${cluster_token}"
}

# Function to create provider account
create_provider_account() {
    local integration_data="$1"
    echo "Creating provider account..."
    
    make_request "PUT" \
        "${CONTROL_PLANE_URL}/api/svc/v1/provider-accounts/" \
        "${integration_data}" \
        "200,201" || handle_error "Failed to create provider account"
}

# Create cluster
echo "Creating cluster..."
cluster_response=$(make_request "PUT" "${CONTROL_PLANE_URL}/api/svc/v1/cluster/" "${cluster_manifest}" "200,201") || \
    handle_error "Failed to create cluster"

echo "Cluster response: ${cluster_response}"
# Parse the cluster response
echo "Parsing cluster response"
cluster_id=$(echo "${cluster_response}" | jq -r '.id') || \
    handle_error "Failed to parse cluster response"

if [ -z "${cluster_id}" ] || [ "${cluster_id}" = "null" ]; then
    handle_error "No cluster ID found in response"
fi

# Get cluster token
cluster_token=$(get_cluster_token "${cluster_id}")
echo "Cluster token: ${cluster_token}"

# Create provider account if config is provided
if [ -n "$PROVIDER_CONFIG_BASE64" ]; then
    echo "Creating provider account..."
    provider_manifest=$(echo "$PROVIDER_CONFIG_BASE64" | base64 -d)
    echo %
    
    provider_response=$(make_request "PUT" \
        "${CONTROL_PLANE_URL}/api/svc/v1/provider-accounts/" \
        "${provider_manifest}" \
        "200,201") || handle_error "\nFailed to create provider account"
    
    echo "Provider account created successfully"
fi

# Create output file with all information
cat > cluster_output.txt <<EOF
CLUSTER_ID=${cluster_id}
CLUSTER_TOKEN=${cluster_token}
TENANT_NAME=${tenant_name}
EOF

echo "Successfully created cluster with ID: ${cluster_id}"