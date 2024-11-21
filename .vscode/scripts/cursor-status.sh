#!/bin/sh

source "$(dirname "$0")/cursor-utils.sh"

if check_server; then
    echo "Cursor server is running on port $CURSOR_PORT"
    echo "Connection URL: $(get_connection_url)"
    echo "PID: $(cat "$PID_FILE")"
else
    echo "Cursor server is not running"
fi 