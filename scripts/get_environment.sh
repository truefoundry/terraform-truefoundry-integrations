#!/bin/bash
set -e -o pipefail
# Read input from stdin (Terraform external data source)
eval "$(jq -r '@sh "
CONTROL_PLANE_URL=\(.control_plane_url)
API_KEY=\(.api_key)
TENANT_NAME=\(.tenant_name)
TRUEFOUNDRY_STDOUT_FILE=\(.stdout_log_file)
TRUEFOUNDRY_STDERR_FILE=\(.stderr_log_file)
"')"

# Logging functions
function log_info() {
    echo "get_environment_name.sh - [INFO] - $1" >> "$TRUEFOUNDRY_STDOUT_FILE"
}

function log_error() {
    echo "get_environment_name.sh - [ERROR] - $1" >> "$TRUEFOUNDRY_STDERR_FILE"
}

# Error handling
function handle_error() {
    log_error "$1"
    jq -n --arg error "$1" '{"error": $error}'
    exit 1
}

[ -z "${CONTROL_PLANE_URL}" ] && handle_error "CONTROL_PLANE_URL is required"
[ -z "${API_KEY}" ] && handle_error "API_KEY is required"
[ -z "${TENANT_NAME}" ] && handle_error "TENANT_NAME is required"
[ -z "${TRUEFOUNDRY_STDOUT_FILE}" ] && handle_error "TRUEFOUNDRY_STDOUT_FILE is required"
[ -z "${TRUEFOUNDRY_STDERR_FILE}" ] && handle_error "TRUEFOUNDRY_STDERR_FILE is required"


echo "" > "$TRUEFOUNDRY_STDOUT_FILE"
echo "" > "$TRUEFOUNDRY_STDERR_FILE"
log_info "Starting script ....\n" >> "$TRUEFOUNDRY_STDOUT_FILE"

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
        log_error "make_request: Request failed with status code: ${http_code}"
        log_error "make_request: Response body:"
        cat "${response_file}" >&2
        rm -f "${response_file}"
        return 1
    fi
    
    # Output response to stdout but only within a function call
    cat "${response_file}"
    rm -f "${response_file}"
    return 0
}


function get_environment_name() {
    log_info "get_environment_name: Getting environment names..."
    local env_response=$(make_request "GET" "${CONTROL_PLANE_URL}/api/svc/v1/environment/" "" "200,201") || \
        handle_error "get_environment_name: Failed to get environment names"

    local environment_name=$(echo "${env_response}" | jq -r '.data[0].name') || \
        handle_error "get_environment_name: Failed to parse environment response"

    [ -z "${environment_name}" ] || [ "${environment_name}" = "null" ] && \
        handle_error "get_environment_name: No environment name found in response"

    echo "${environment_name}"
}

function main() {
    local environment_name
    
    # Verify platform health
    log_info "main: Checking platform health..."
    
    make_request "GET" "${CONTROL_PLANE_URL}/api/svc/" "" "200" >/dev/null || \
        handle_error "main: Platform health check failed"

    # Get environment and create cluster
    environment_name=$(get_environment_name)
    log_info "main: Environment name: ${environment_name}"

    # Use provided tenant name
    log_info "main: Tenant name: ${TENANT_NAME}"
        
    # Output only the final JSON result to stdout
    jq -n \
        --arg environment_name "$environment_name" \
        --arg tenant_name "$TENANT_NAME" \
        '{
            environment_name: $environment_name,
            tenant_name: $tenant_name
        }'
}

output=$(main)
echo "$output"
log_info "Completed script ..." >> "$TRUEFOUNDRY_STDOUT_FILE"