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

function is_cluster_provisioned() {
    log_info "is_cluster_provisioned: Checking if cluster exists and is provisioned..."

    # Validate prerequisites
    if [ -z "$API_KEY" ] || [ -z "$CONTROL_PLANE_URL" ]; then
        log_error "is_cluster_provisioned: API_KEY or CONTROL_PLANE_URL is not set."
        return 1
    fi

    # Make GET request to check cluster status
    local response=$(mktemp)
    local http_status=$(curl -s -o "$response" -w "%{http_code}" \
        -H "Accept: application/json" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${API_KEY}" \
        "${CONTROL_PLANE_URL}/api/svc/v1/cluster/${CLUSTER_NAME}")

    # Read the response body
    local http_body
    http_body=$(cat "$response")
    rm "$response"

    # Check if the request was successful
    if [ "$http_status" = "200" ]; then
        local provisioned
        provisioned=$(echo "$http_body" | jq -r '.provisioned')
        if [ "$provisioned" == "true" ]; then
            log_info "is_cluster_provisioned: Cluster is already provisioned."
            return 0
        else
            log_info "is_cluster_provisioned: Cluster exists but is not provisioned."
            setup_provider_account || {
              log_error "is_cluster_provisioned: Failed to provision the cluster."
              return 1
            }
        fi
    elif [ "$http_status" = "400" ]; then
        log_error "is_cluster_provisioned: Cluster not found."
        return 1
    else
        log_error "is_cluster_provisioned: Failed to check cluster status. HTTP status: $http_status"
        return 1
    fi
}

function create_cluster() {
    log_info "create_cluster: Creating cluster..."

    [-z "$CLUSTER_CONFIG_BASE64"] && handle_error "$CLUSTER_CONFIG_BASE64 is required" && return 1

    local manifest=$(echo "$CLUSTER_CONFIG_BASE64" | base64 -d)

    log_info "create_cluster: cluster manifest ${manifest}"
    local response=$(make_request "PUT" "${CONTROL_PLANE_URL}/api/svc/v1/cluster/" "${manifest}" "200,201") || \
        handle_error "create_cluster: Failed to create cluster"

    log_info "create_cluster: Response $response"

    local cluster_id=$(echo "${response}" | jq -r '.id') || \
        handle_error "create_cluster: Failed to parse cluster response"

    log_info "create_cluster: Cluster ID $cluster_id"

    [ -z "${cluster_id}" ] && handle_error "create_cluster: No cluster ID found in response" && return 1

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

    [ -z "${token}" ] && handle_error "No cluster token found in response" && return 1

    echo "${token}"
}

# Provider operations
function setup_provider_account() {
    log_info "setup_provider_account: Starting provider account setup..."

    # Ensure required environment variables are set
    if [ -z "$PROVIDER_CONFIG_BASE64" ]; then
        handle_error "setup_provider_account: PROVIDER_CONFIG_BASE64 is required"
        return 1
    fi

    if [ -z "$API_KEY" ] || [ -z "$CONTROL_PLANE_URL" ]; then
        handle_error "setup_provider_account: API_KEY and CONTROL_PLANE_URL must be set"
        return 1
    fi

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
        is_cluster_provisioned
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
