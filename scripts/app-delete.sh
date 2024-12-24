#!/bin/bash

app_id="$1"

source "$(dirname "$0")/common.sh"

call_api "/app/$app_id/delete" "DELETE" "" "" "200 404"
