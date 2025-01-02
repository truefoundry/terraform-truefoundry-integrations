#!/bin/bash
set -e -o pipefail

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
# Error handling
function handle_error() {
    local error_message="$1"
    echo "[ERROR] $error_message" >&2
    exit 1
}

# Logging functions
function log_info() {
    echo "[INFO] $1" >> "$TRUEFOUNDRY_STDOUT_FILE"
}

function log_error() {
    echo "[ERROR] $1" >> "$TRUEFOUNDRY_STDERR_FILE"
}

# Validate required parameters
[ -z "${CONTROL_PLANE_URL}" ] && handle_error "CONTROL_PLANE_URL is required"
[ -z "${API_KEY}" ] && handle_error "API_KEY is required"
[ -z "${CLUSTER_NAME}" ] && handle_error "CLUSTER_NAME is required"
[ -z "${CLUSTER_TYPE}" ] && handle_error "CLUSTER_TYPE is required"

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
    eval "${curl_cmd} '${url}'" > "${response_file}" 2>>"$TRUEFOUNDRY_STDERR_FILE"
    local curl_exit_code=$?

    # Get HTTP status code, redirect all output to stderr
    eval "${curl_cmd} -o /dev/null -w '%{http_code}' '${url}'" > "${http_code_file}" 2>>"$TRUEFOUNDRY_STDERR_FILE"
    local http_code=$(<"${http_code_file}")

    # Cleanup
    rm -f "${http_code_file}"

    # Validate response
    if [ $curl_exit_code -ne 0 ]; then
        local error_msg="Curl command failed with exit code: ${curl_exit_code}"
        rm -f "${response_file}"
        handle_error "$error_msg"
        return 1
    fi

    if [[ ! ",$expected_status_codes," =~ ,"${http_code}", ]]; then
        local error_msg="Request failed with status code: ${http_code}"
        log_error "$error_msg"
        log_error "Response body:"
        cat "${response_file}" >> "$TRUEFOUNDRY_STDERR_FILE"
        rm -f "${response_file}"
        handle_error "$error_msg"
        return 1
    fi
    
    # Output response
    cat "${response_file}"
    rm -f "${response_file}"
    return 0
}


function is_cluster_provisioned() {
    log_info "is_cluster_provisioned: Checking if cluster exists and is provisioned..."

    # Make GET request to check cluster status
    local response=$(make_request "GET" "${CONTROL_PLANE_URL}/api/svc/v1/cluster/${CLUSTER_NAME}" "" "200") || {
        log_info "is_cluster_provisioned: Cluster doesn't exist, creating ${CLUSTER_NAME} in control plane"
        return 0
    }
    
    # Check if the request was successful
    local provisioned
    provisioned=$(echo "$response" | jq -r '.provisioned')
    if [ "$provisioned" == "true" ]; then
        log_info "is_cluster_provisioned: Cluster is already provisioned."
    else
        log_info "is_cluster_provisioned: Cluster exists but is not provisioned."
    fi
}

function create_cluster() {
    log_info "create_cluster: Creating cluster..."

    [ -z "$CLUSTER_CONFIG_BASE64" ] && handle_error "CLUSTER_CONFIG_BASE64 is required" && return 1

    local manifest=$(echo "$CLUSTER_CONFIG_BASE64" | base64 -d)
    [ $? -ne 0 ] && handle_error "Failed to decode CLUSTER_CONFIG_BASE64"

    log_info "create_cluster: cluster manifest ${manifest}"
    
    local response=$(make_request "PUT" "${CONTROL_PLANE_URL}/api/svc/v1/cluster/" "${manifest}" "200,201")
    [ $? -ne 0 ] && handle_error "Failed to create cluster"

    log_info "create_cluster: Response $response"

    local cluster_id=$(echo "${response}" | jq -r '.id')
    [ $? -ne 0 ] && handle_error "Failed to parse cluster response"


    log_info "create_cluster: Cluster ID $cluster_id"
    [ -z "${cluster_id}" ] && handle_error "No cluster ID found in response"

    echo "${cluster_id}"
}

function get_cluster_token() {
    local cluster_id="$1"
    [ -z "$cluster_id" ] && handle_error "Cluster ID is required for token generation"
    log_info "get_cluster_token: Getting cluster token..."

    local response=$(make_request "GET" \
        "${CONTROL_PLANE_URL}/api/svc/v1/cluster/${cluster_id}/token" \
        "" "200")
    [ $? -ne 0 ] && handle_error "Failed to get cluster token"
    
    local token=$(echo "${response}" | jq -r '.clusterToken')
    [ $? -ne 0 ] && handle_error "Failed to parse cluster token response"
    [ -z "${token}" ] && handle_error "No cluster token found in response" && return 1
    
    echo "${token}"
}

function setup_provider_account() {
    log_info "setup_provider_account: Starting provider account setup..."

    # Ensure required environment variables are set
    [ -z "$PROVIDER_CONFIG_BASE64" ] && handle_error "setup_provider_account: PROVIDER_CONFIG_BASE64 is required"
    

    log_info "setup_provider_account: Creating provider account..."

    # Decode the provider configuration
    local provider_manifest
    provider_manifest=$(echo "$PROVIDER_CONFIG_BASE64" | base64 -d)
    if [ $? -ne 0 ]; then
        handle_error "setup_provider_account: Failed to decode PROVIDER_CONFIG_BASE64"
        return 1
    fi

    log_info "setup_provider_account: Provider account manifest: ${provider_manifest}"

    # Make a PUT request to create the provider account
    local response
    response=$(make_request "PUT" \
        "${CONTROL_PLANE_URL}/api/svc/v1/provider-accounts/" \
        "${provider_manifest}" \
        "200,201") || {
        handle_error "setup_provider_account: Failed to create provider account"
        return 1
    }

    log_info "setup_provider_account: Provider account created successfully."
    return 0
}

function main() {
    # Verify platform health
    log_info "main: Checking platform health..."
    make_request "GET" "${CONTROL_PLANE_URL}/api/svc/" "" "200" >/dev/null || handle_error "Platform health check failed"

    local cluster_id
    local cluster_token

    # Check if cluster exists and is provisioned
        local cluster_status=$(is_cluster_provisioned)
        log_info "main: Cluster status: ${cluster_status}"
        
    if [ "${cluster_status}" = "true" ]; then
            log_info "main: Cluster already exists and is provisioned. Skipping creation."
            # Get existing cluster ID from the response
            cluster_id=$(make_request "GET" "${CONTROL_PLANE_URL}/api/svc/v1/cluster/${CLUSTER_NAME}" "" "200" | jq -r '.id')
    else
        if [ "${CLUSTER_TYPE}" != "generic" ]; then
            # Setup provider account and create cluster if not provisioned or doesn't exist
            setup_provider_account || handle_error "Failed to setup provider account"
            cluster_id=$(create_cluster) || handle_error "Failed to create cluster"
        else
            cluster_id=$(create_cluster) || handle_error "Failed to create cluster"
        fi
    fi


    cluster_token=$(get_cluster_token "${cluster_id}") || handle_error "Failed to get cluster token"

    log_info "main: cluster_id=$cluster_id"
    log_info "main: cluster_token=$cluster_token"

    # Output the final JSON result to stdout
    jq -n \
        --arg cluster_id "$cluster_id" \
        --arg cluster_token "$cluster_token" \
        '{
            cluster_id: $cluster_id,
            cluster_token: $cluster_token
        }'
}

# Execute main function directly
main
