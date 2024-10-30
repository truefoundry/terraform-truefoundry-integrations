#!/bin/bash
set -e

# Configuration variables
CONTROL_PLANE_URL="$1"
API_KEY="$2"
CLUSTER_NAME="$3"
CLUSTER_TYPE="$4"
PROVIDER_CONFIG_BASE64="$5"
OUTPUT_FILE="$6"

# Logging functions
log_info() {
    echo "[INFO] $1" >&2
}

log_error() {
    echo "[ERROR] $1" >&2
}

# Error handling
handle_error() {
    log_error "$1"
    exit 1
}

# HTTP request handler
make_request() {
    local method="$1"
    local url="$2"
    local body="$3"
    local expected_status_codes="$4"
    local response_file=$(mktemp)
    local http_code_file=$(mktemp)
    
    log_info "Making ${method} request to ${url}"
    
    local curl_cmd="curl -s -X ${method} \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -H 'Authorization: Bearer ${API_KEY}'"

    [ -n "$body" ] && curl_cmd="$curl_cmd -d '${body}'"
    
    # Execute request and capture response
    eval "${curl_cmd} '${url}'" > "${response_file}" 2>/dev/null
    local curl_exit_code=$?
    
    # Get HTTP status code
    eval "${curl_cmd} -o /dev/null -w '%{http_code}' '${url}'" > "${http_code_file}" 2>/dev/null
    local http_code=$(<"${http_code_file}")
    
    # Cleanup
    rm -f "${http_code_file}"
    
    # Validate response
    if [ $curl_exit_code -ne 0 ]; then
        rm -f "${response_file}"
        return 1
    fi
    
    if [[ ! ",$expected_status_codes," =~ ,"${http_code}", ]]; then
        log_error "Request failed with status code: ${http_code}"
        log_error "Response body:"
        cat "${response_file}" >&2
        rm -f "${response_file}"
        return 1
    fi
    
    cat "${response_file}"
    rm -f "${response_file}"
    return 0
}

# Environment operations
get_environment_name() {
    log_info "Getting environment names..."
    local env_response=$(make_request "GET" "${CONTROL_PLANE_URL}/api/svc/v1/environment/" "" "200,201") || \
        handle_error "Failed to get environment names"

    local environment_name=$(echo "${env_response}" | jq -r '.[0].name') || \
        handle_error "Failed to parse environment response"

    [ -z "${environment_name}" ] || [ "${environment_name}" = "null" ] && \
        handle_error "No environment name found in response"

    echo "${environment_name}"
}

# Cluster operations
generate_cluster_manifest() {
    local env_name="$1"
    cat <<EOF
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
    "environment_names": ["${env_name}"]
  }
}
EOF
}

create_cluster() {
    local manifest="$1"
    log_info "Creating cluster..."
    local response=$(make_request "PUT" "${CONTROL_PLANE_URL}/api/svc/v1/cluster/" "${manifest}" "200,201") || \
        handle_error "Failed to create cluster"
    
    local cluster_id=$(echo "${response}" | jq -r '.id') || \
        handle_error "Failed to parse cluster response"

    [ -z "${cluster_id}" ] || [ "${cluster_id}" = "null" ] && \
        handle_error "No cluster ID found in response"

    echo "${cluster_id}"
}

get_cluster_token() {
    local cluster_id="$1"
    log_info "Getting cluster token..."
    
    local response=$(make_request "GET" \
        "${CONTROL_PLANE_URL}/api/svc/v1/cluster/${cluster_id}/token" \
        "" "200") || handle_error "Failed to get cluster token"
    
    local token=$(echo "${response}" | jq -r '.clusterToken') || \
        handle_error "Failed to parse cluster token response"

    [ -z "${token}" ] || [ "${token}" = "null" ] && \
        handle_error "No cluster token found in response"
    
    echo "${token}"
}

# Tenant operations
get_tenant_name() {
    log_info "Getting tenant name..."
    local hostname=$(echo "$CONTROL_PLANE_URL" | awk -F[/:] '{print $4}')
    
    local response=$(make_request "GET" \
        "${CONTROL_PLANE_URL}/api/auth/api/v1/tenant-config/public?hostName=${hostname}" \
        "" "200,201") || handle_error "Failed to get tenant config"
    
    local tenant_name=$(echo "${response}" | jq -r '.tenantName') || \
        handle_error "Failed to parse tenant config response"

    [ -z "${tenant_name}" ] || [ "${tenant_name}" = "null" ] && \
        handle_error "No tenant name found in response"
    
    echo "${tenant_name}"
}


# Provider operations
setup_provider_account() {
    [ -z "$PROVIDER_CONFIG_BASE64" ] && return
    
    log_info "Creating provider account..."
    local provider_manifest=$(echo "$PROVIDER_CONFIG_BASE64" | base64 -d)
    
    make_request "PUT" \
        "${CONTROL_PLANE_URL}/api/svc/v1/provider-accounts/" \
        "${provider_manifest}" \
        "200,201" || handle_error "Failed to create provider account"
    
    log_info "Provider account created successfully"
}

# Output handling
write_outputs() {
    local cluster_id="$1"
    local cluster_token="$2"
    local tenant_name="$3"
    
    log_info "Writing outputs to ${OUTPUT_FILE}"
    
    # Write to output file
    cat > "${OUTPUT_FILE}" <<EOF
CLUSTER_ID=${cluster_id}
CLUSTER_TOKEN=${cluster_token}
TENANT_NAME=${tenant_name}
EOF

    if [ -f "${OUTPUT_FILE}" ]; then
        log_info "Successfully wrote to ${OUTPUT_FILE}"
    else
        log_error "Failed to create ${OUTPUT_FILE}"
        exit 1
    fi
}

# Main execution
main() {
    # Verify platform health
    log_info "Checking platform health..."
    make_request "GET" "${CONTROL_PLANE_URL}/api/svc/" "" "200" || \
        handle_error "Platform health check failed"

    # Get environment and create cluster
    local environment_name=$(get_environment_name)
    log_info "Found environment: ${environment_name}"

    local cluster_manifest=$(generate_cluster_manifest "${environment_name}")
    local cluster_id=$(create_cluster "${cluster_manifest}")
    local cluster_token=$(get_cluster_token "${cluster_id}")
    
    # Setup provider account if configured
    setup_provider_account

    # Get tenant information
    local tenant_name=$(get_tenant_name)

    # Write outputs to files
    write_outputs "${cluster_id}" "${cluster_token}" "${tenant_name}" 
    ls -l cluster_output.txt
    pwd
    log_info "Successfully created cluster with ID: ${cluster_id}"
}

# Execute main function
main