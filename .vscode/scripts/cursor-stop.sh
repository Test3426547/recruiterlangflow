#!/bin/bash

. "$(dirname "$0")/cursor-utils.sh"

if check_server; then
    PID=$(cat "$PID_FILE")
    kill "$PID"
    rm -f "$PID_FILE"
    echo "Cursor server stopped"
else
    echo "No Cursor server running"
fi 