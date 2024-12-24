#!/bin/bash

source "$(dirname "$0")/common.sh"

call_api "/user" "GET" "" "" "200"
