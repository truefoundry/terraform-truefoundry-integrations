#!/bin/bash
set -e

# Read input from stdin (Terraform external data source)
eval "$(jq -r '@sh "
CONTROL_PLANE_URL=\(.control_plane_url)
API_KEY=\(.api_key)
CLUSTER_NAME=\(.cluster_name)
CLUSTER_TYPE=\(.cluster_type)
CLUSTER_CONFIG_BASE64=\(.cluster_config_base64)
PROVIDER_CONFIG_BASE64=\(.provider_config_base64)
TRUEFOUNDRY_STDOUT_FILE=\(.stdout_log_file)
TRUEFOUNDRY_STDERR_FILE=\(.stderr_log_file)
"')"


# Validate required parameters
[ -z "${CONTROL_PLANE_URL}" ] && handle_error "CONTROL_PLANE_URL is required" && return 1
[ -z "${API_KEY}" ] && handle_error "API_KEY is required" && return 1
[ -z "${CLUSTER_NAME}" ] && handle_error "CLUSTER_NAME is required" && return 1
[ -z "${CLUSTER_TYPE}" ] && handle_error "CLUSTER_TYPE is required" && return 1

# Logging functions
function log_info() {
    echo "[INFO] $1" >> $TRUEFOUNDRY_STDOUT_FILE
}

function log_error() {
    echo "[ERROR] $1" >> $TRUEFOUNDRY_STDERR_FILE
}

# Error handling
function handle_error() {
    log_error "$1"
    jq -n --arg error "$1" '{"error": $error}'
    exit 1
}

# HTTP request handler
function make_request() {
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


function create_cluster() {
    log_info "create_cluster: Creating cluster..."

    [-z "$CLUSTER_CONFIG_BASE64"] && handle_error "$CLUSTER_CONFIG_BASE64 is required" && return 1
    
    local manifest=$(echo "$CLUSTER_CONFIG_BASE64" | base64 -d)

    log_info "create_cluster:: cluster manifest ${manifest}"
    local response=$(make_request "PUT" "${CONTROL_PLANE_URL}/api/svc/v1/cluster/" "${manifest}" "200,201") || \
        handle_error "create_cluster: Failed to create cluster"
    
    local cluster_id=$(echo "${response}" | jq -r '.id') || \
        handle_error "create_cluster: Failed to parse cluster response"

    [ -z "${cluster_id}" ] || [ "${cluster_id}" = "null" ] || \
        handle_error "create_cluster: No cluster ID found in response"

    echo "${cluster_id}"
}

function get_cluster_token() {
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

# Provider operations
function setup_provider_account() {
    
    [ -z "$PROVIDER_CONFIG_BASE64" ] && handle_error "$CLUSTER_CONFIG_BASE64 is required" && return 1
    
    log_info "setup_provider_account: Creating provider account..."
    local provider_manifest=$(echo "$PROVIDER_CONFIG_BASE64" | base64 -d)
    
    log_info "setup_provider_account: provider account manifest ${provider_manifest}"
    local response=$(make_request "PUT" \
        "${CONTROL_PLANE_URL}/api/svc/v1/provider-accounts/" \
        "${provider_manifest}" \
        "200,201") || handle_error "setup_provider_account: Failed to create provider account"
    
    log_info "setup_provider_account: Provider account created successfully"
}

# Main execution
function main() {
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

    # Setup provider account if configured and cluster type is not generic
    if [ "${CLUSTER_TYPE}" != "generic" ]; then
        setup_provider_account
    fi

    cluster_id=$(create_cluster)
    cluster_token=$(get_cluster_token "${cluster_id}")

    log_info "main: cluster_id=$cluster_id"
    log_info "main: cluster_token=$cluster_token"

    # Output only the final JSON result to stdout
    jq -n \
        --arg cluster_id "$cluster_id" \
        --arg cluster_token "$cluster_token" \
        '{
            cluster_id: $cluster_id,
            cluster_token: $cluster_token,
        }'
}

# Execute main function and ensure only JSON output goes to stdout
output=$(main)
echo "$output"