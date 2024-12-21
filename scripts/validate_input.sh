#!/bin/bash

source "$(dirname "$0")/common.sh"

command=$1

if [[ "$command" != "userinfo" && \
      "$command" != "delete" && \
      "$command" != "status" && \
      "$command" != "upload" && \
      "$command" != "commit" ]]; then
  echo "[ERROR] Unknown command: $command"
  return 1
fi
