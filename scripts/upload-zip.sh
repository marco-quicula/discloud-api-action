#!/bin/bash

file="$1"

source "$(dirname "$0")/common.sh"

call_api "/upload" "POST" "" "$file" "200"
