#!/bin/bash

# "Set the base URL for the API"
base_url="https://api.discloud.app/v2"

# "Set outputs for GitHub Actions"
set_github_output() {
  local name="$1"
  local value="$2"

  echo "Include in $GITHUB_OUTPUT: $name=$value"
  echo "$name=$value" >> "$GITHUB_OUTPUT"
  # shellcheck disable=SC2016
  echo "GITHUB_OUTPUT: $(cat '$GITHUB_OUTPUT')"
}

call_api() {
  local endpoint="$1"
  local method="${2:-GET}"
  local data="${3:-}"
  local file="${4:-}"  # Path to a file, if necessary

  # Ensure API token is present
  if [[ -z "$DISCLOUD_API_TOKEN" ]]; then
    echo "[ERROR] $endpoint: The API token was not provided."
    set_github_output "http_code" "401"
    set_github_output "response_body" "{}"
    set_github_output "error_message" "The API token was not provided."
    set_github_output "response_source" "internal"
    return 1
  fi

  # Define headers and payload depending on the type of call
  local curl_args=(
    -s
    -w "%{http_code}"
    -X "$method"
    --location "${base_url}${endpoint}"
    -H "api-token: ${DISCLOUD_API_TOKEN}"
  )

  if [[ -n "$file" ]]; then
    # For file uploads, we use multipart/form-data
    curl_args+=(-F "file=@${file}")
  elif [[ -n "$data" ]]; then
    # For JSON or other content in the body
    curl_args+=(-H "Content-Type: application/json" --data "$data")
  fi

  # Execute the curl command
  local response
  response=$(curl "${curl_args[@]}")

  # Process the HTTP code and response body
  local http_code="${response: -3}"
  local response_body="${response:0:${#response}-3}"

  # Check for API errors
  if [[ "$http_code" -ge 400 ]]; then
    local error_message
    error_message=$(echo "$response_body" | jq -r '.message // "Unknown error"')
    echo "[ERROR] $endpoint: API call failed with HTTP Code $http_code - $error_message"
    set_github_output "http_code" "$http_code"
    set_github_output "response_body" "$response_body"
    set_github_output "error_message" "$error_message"
    set_github_output "response_source" "api"
    return 1
  fi

  # Success
  echo "[INFO] $endpoint: API call successful"
  set_github_output "http_code" "$http_code"
  set_github_output "response_body" "$response_body"
  set_github_output "error_message" ""
  set_github_output "response_source" "api"
  return 0
}
