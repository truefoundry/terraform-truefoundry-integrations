#!/bin/bash
set -e

# Read input from stdin (Terraform external data source)
eval "$(jq -r '@sh "
CONTROL_PLANE_URL=\(.control_plane_url)
API_KEY=\(.api_key)
CLUSTER_NAME=\(.cluster_name)
CLUSTER_TYPE=\(.cluster_type)
PROVIDER_CONFIG_BASE64=\(.provider_config_base64)
TRUEFOUNDRY_STDOUT_FILE=\(.stdout_log_file)
TRUEFOUNDRY_STDERR_FILE=\(.stderr_log_file)
"')"

echo "" > $TRUEFOUNDRY_STDOUT_FILE


# Validate required parameters
[ -z "${CONTROL_PLANE_URL}" ] && handle_error "CONTROL_PLANE_URL is required"
[ -z "${API_KEY}" ] && handle_error "API_KEY is required"
[ -z "${CLUSTER_NAME}" ] && handle_error "CLUSTER_NAME is required"
[ -z "${CLUSTER_TYPE}" ] && handle_error "CLUSTER_TYPE is required"

# Logging functions
log_info() {
    echo "[INFO] $1" >> $TRUEFOUNDRY_STDOUT_FILE
}

log_error() {
    echo "[ERROR] $1" >> $TRUEFOUNDRY_STDERR_FILE
}

log_info $PROVIDER_CONFIG_BASE64

# Error handling
handle_error() {
    log_error "$1"
    jq -n --arg error "$1" '{"error": $error}'
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
    
    log_info "make_request: Making ${method} request to ${url}"
    
    local curl_cmd="curl -s -X ${method} \
        -H 'Accept: application/json' \
        -H 'Content-Type: application/json' \
        -H 'Authorization: Bearer ${API_KEY}'"

    [ -n "$body" ] && curl_cmd="$curl_cmd -d '${body}'"
    
    # Execute request and capture response, redirect all output to stderr
    eval "${curl_cmd} '${url}'" > "${response_file}" 2>&2
    local curl_exit_code=$?
    
    # Get HTTP status code, redirect all output to stderr
    eval "${curl_cmd} -o /dev/null -w '%{http_code}' '${url}'" > "${http_code_file}" 2>&2
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
    
    # Output response to stdout but only within a function call
    cat "${response_file}"
    rm -f "${response_file}"
    return 0
}

# Environment operations
get_environment_name() {
    log_info "get_environment_name: Getting environment names..."
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
    log_info "create_cluster: Creating cluster..."
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
    log_info "get_cluster_token: Getting cluster token..."
    
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
    log_info "get_tenant_name: Getting tenant name..."
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
    
    log_info "setup_provider_account: Creating provider account..."
    local provider_manifest=$(echo "$PROVIDER_CONFIG_BASE64" | base64 -d)
    
    log_info "setup_provider_account: ${provider_manifest}"
    make_request "PUT" \
        "${CONTROL_PLANE_URL}/api/svc/v1/provider-accounts/" \
        "${provider_manifest}" \
        "200,201" || handle_error "Failed to create provider account"
    
    log_info "setup_provider_account: Provider account created successfully"
}

# Main execution
main() {
    # Capture all output in variables to prevent unwanted stdout
    local environment_name
    local cluster_manifest
    local cluster_id
    local cluster_token
    local tenant_name

    # Verify platform health
    log_info "main: Checking platform health..."
    make_request "GET" "${CONTROL_PLANE_URL}/api/svc/" "" "200" >/dev/null || \
        handle_error "Platform health check failed"

    # Get environment and create cluster
    environment_name=$(get_environment_name)
    log_info "main: Found environment: ${environment_name}"

    # Setup provider account if configured and cluster type is not generic
    if [ "${CLUSTER_TYPE}" != "generic" ]; then
        setup_provider_account
    fi
    cluster_manifest=$(generate_cluster_manifest "${environment_name}")
    log_info "main: ${cluster_manifest}"
    cluster_id=$(create_cluster "${cluster_manifest}")
    cluster_token=$(get_cluster_token "${cluster_id}")

    # Get tenant information
    tenant_name=$(get_tenant_name)

    log_info "main: cluster_id=$cluster_id"
    log_info "main: cluster_token=$cluster_token"
    log_info "main: tenant_name=$tenant_name"

    # Output only the final JSON result to stdout
    jq -n \
        --arg cluster_id "$cluster_id" \
        --arg cluster_token "$cluster_token" \
        --arg tenant_name "$tenant_name" \
        '{
            cluster_id: $cluster_id,
            cluster_token: $cluster_token,
            tenant_name: $tenant_name
        }'
}

# Execute main function and ensure only JSON output goes to stdout
output=$(main)
echo "$output"