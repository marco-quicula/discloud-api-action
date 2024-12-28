#!/bin/bash

# Input: File path and action if it exists
file="$1"
actionIfExists="$2"

# Import common functions
source "$(dirname "$0")/common.sh"

# Handle action "ERROR": Upload the file and exit
if [[ "$actionIfExists" == "ERROR" ]]; then
  call_api "/upload" "POST" "" "$file" "200"
  exit 0
fi

# Get the application ID from the file
app_id=$(get_appId_from_file "$file")

echo "[INFO] Application ID: $app_id"

# Handle action "DELETE": Delete the application and upload the file
if [[ "$actionIfExists" == "DELETE" ]]; then
  call_api "/app/$app_id/delete" "DELETE" "" "" "200"
  call_api "/upload" "POST" "" "$file" "200"
  exit 0
fi

# Variable to store the HTTP status code from the status check
http_code=""

# Check the application status
call_api "/app/$app_id/status" "GET" "" "" "200 404"

# Handle action "COMMIT" if the HTTP status code is 200
if [[ "$actionIfExists" == "COMMIT" && "$http_code" == "200" ]]; then
  call_api "/app/$app_id/commit" "PUT" "" "$file" "200"
elif [[ "$http_code" == "404" ]]; then
  # Perform upload only if the status is 404
  call_api "/upload" "POST" "" "$file" "200"
else
  # Error if the HTTP code is neither 200 nor 404
  echo "[ERROR] Unexpected http_code: $http_code. Expected 200 or 404."
  exit 1
fi
