#!/bin/bash

file="$1"
app_id="$2"

# Import common functions
source "$(dirname "$0")/common.sh"

# Check if app_id is provided or empty
if [[ -z "$app_id" ]]; then
  # Get the application ID from the file
  app_id=$(get_appId_from_file "$file")
  if [[ -z "$app_id" ]]; then
    echo "[ERROR] Application ID not found in file and not provided as input."
    exit 1
  fi
fi

# Perform the commit operation
call_api "/app/$app_id/commit" "PUT" "" "$file" "200"
