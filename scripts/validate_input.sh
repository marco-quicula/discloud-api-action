#!/bin/bash

source "$(dirname "$0")/common.sh"

command=$1 # command, first argument
appId=$2   # appId, second argument

# Check if the command is valid
if [[ "$command" != "userinfo" && \
      "$command" != "app-status" && \
      "$command" != "delete" && \
      "$command" != "upload" && \
      "$command" != "commit" ]]; then
  echo "[ERROR] Unknown command: $command"
  return 1
fi

# Check if appId is provided and not empty when the command is app-status
if [[ "$command" == "app-status" && ( -z "$appId" || "$appId" == "" ) ]]; then
  echo "[ERROR] The appId must be provided and not be empty for the 'app-status' command"
  return 1
fi
