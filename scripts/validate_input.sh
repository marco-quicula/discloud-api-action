#!/bin/bash

source "$(dirname "$0")/common.sh"

command=$1 # command, first argument
appId=$2   # appId, second argument
file=$3 # file, third argument for app-update actionIfExists=$4 # actionIfExists, fourth argument for app-update
actionIfExists=$4 # actionIfExists, fourth argument for app-update

# Check if the command is valid
if [[ "$command" != "userinfo" && \
      "$command" != "app-status" && \
      "$command" != "app-delete" && \
      "$command" != "upload-zip" && \
      "$command" != "app-commit" ]]; then
  echo "[ERROR] Unknown command: $command"
  exit 1
fi

# Check if appId is provided and not empty when the command is app-status
if [[ "$command" == "app-status" && ( -z "$appId" || "$appId" == "" ) ]]; then
  echo "[ERROR] The appId must be provided and not be empty for the 'app-status' command"
  exit 1
fi

# Check if file is provided and not empty when the command is update-zip
if [[ "$command" == "upload-zip" && ( -z "$file" || "$file" == "" ) ]]; then
  echo "[ERROR] The file must be provided and not be empty for the 'upload-zip' command"
  exit 1
fi

# Check if actionIfExists is valid for upload-zip
if [[ "$command" == "upload-zip" && "$actionIfExists" != "" && \
      "$actionIfExists" != "ERROR" && \
      "$actionIfExists" != "DELETE" && \
      "$actionIfExists" != "COMMIT" ]]; then
  echo "[ERROR] Invalid actionIfExists: $actionIfExists. Must be one of ERROR, DELETE, or COMMIT."
  exit 1
fi

# Check if file is provided and not empty when the command is app-commit
if [[ "$command" == "app-commit" && ( -z "$file" || "$file" == "" ) ]]; then
  echo "[ERROR] The file must be provided and not be empty for the 'app-commit' command"
  exit 1
fi