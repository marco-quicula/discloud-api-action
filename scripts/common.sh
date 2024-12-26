#!/bin/bash

# "Set the base URL for the API"
base_url="https://api.discloud.app/v2"

# "Set outputs for GitHub Actions"
set_github_output() {
  local name="$1"
  local value="$2"
  echo "$name=$value" >> "$GITHUB_OUTPUT"
}

call_api() {
  local endpoint="$1"
  local method="${2:-GET}"
  local data="${3:-}"
  local file="${4:-}"  # Path to a file, if necessary
  local acceptable_codes="${5:-}" # List of acceptable HTTP codes

  # Ensure the API token is present
  if [[ -z "$DISCLOUD_API_TOKEN" ]]; then
    echo "[ERROR] $endpoint: The API token was not provided."
    set_github_output "http_code" "401"
    set_github_output "response_body" "{}"
    set_github_output "error_message" "The API token was not provided."
    set_github_output "response_source" "internal"
    return 1
  fi

  # Define headers and payload depending on the type of request
  local curl_args=(
    -s
    -w "%{http_code}"
    -X "$method"
    --location "${base_url}${endpoint}"
    -H "api-token: ${DISCLOUD_API_TOKEN}"
  )

  if [[ -n "$file" ]]; then
    # For file uploads, use multipart/form-data
    curl_args+=(-F "file=@${file}")
  elif [[ -n "$data" ]]; then
    # For JSON or other content in the request body
    curl_args+=(-H "Content-Type: application/json" --data "$data")
  fi

  # Execute the curl command
  local response
  response=$(curl "${curl_args[@]}")

  echo "Saída do response $response"

  # Process the HTTP code and response body
  http_code="${response: -3}"
  error_message=""
  local response_body="${response:0:${#response}-3}"
  response_body_base64=$(echo -n "$response_body" | base64 | tr -d '\n' | tr -d '\r')
  response_source="api"

  # Check if the HTTP code is in the list of acceptable codes
  if [[ -n "$acceptable_codes" ]]; then
    for code in $acceptable_codes; do
      if [[ "$code" == "$http_code" ]]; then
        echo "[INFO] $endpoint: API call returned acceptable HTTP Code $http_code"
        set_github_output "http_code" "$http_code"
        set_github_output "response_body" "$response_body_base64"
        set_github_output "error_message" ""
        set_github_output "response_source" "$response_source"
        return 0
      fi
    done
  fi

  # If the code is not acceptable, treat it as an error
  error_message=$(echo "$response_body" | jq -r '.message // "Unknown error"')
  echo "[ERROR] $endpoint: API call failed with HTTP Code $http_code - $error_message"
  set_github_output "http_code" "$http_code"
  set_github_output "response_body" "$response_body_base64"
  set_github_output "error_message" "$error_message"
  set_github_output "response_source" "$response_source"
  return 1
}

get_appId_from_file() {
  local file=$1 # Zip file name passed as first argument
  local temp_dir
  temp_dir=$(mktemp -d) # Create a temporary directory to extract the zip file

  # Extract the discloud.config file from the zip file
  unzip -p "$file" discloud.config > "$temp_dir/discloud.config"

  # Read the content of the discloud.config file and find the line with ID=value or id=value
  local id_line
  id_line=$(grep -i '^id=' "$temp_dir/discloud.config")

  # Extract the value from the line ID=value or id=value (after the equals sign)
  local id_value
  id_value=$(echo "$id_line" | cut -d'=' -f2)

  # Get only the first term before the dot
  local first_term
  first_term=$(echo "$id_value" | cut -d'.' -f1)

  # Clean up the temporary directory
  rm -rf "$temp_dir"

  # Return the first term
  echo "$first_term"
}
