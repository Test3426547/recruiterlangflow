#!/bin/bash

# Import utilities
. "$(dirname "$0")/cursor-utils.sh"

# Check prerequisites
check_prerequisites

if check_server; then
    log_info "Cursor server is already running on port $CURSOR_PORT"
    exit 0
fi

# Start server
log_info "Starting Cursor server on port $CURSOR_PORT"
"$CURSOR_SERVER_DIR/cli/servers/$CURSOR_VERSION/server/bin/cursor-server" \
    --host=0.0.0.0 \
    --port=$CURSOR_PORT \
    --without-connection-token \
    --disable-workspace-trust \
    --server-data-dir="$CURSOR_SERVER_DIR/data" \
    --default-folder="$WORKSPACE_ROOT" \
    --extensions-download-dir="$CURSOR_SERVER_DIR/extensions" \
    --start-server \
    --do-not-sync 2>&1 | tee -a "$LOG_FILE" &

# Save PID
echo $! > "$PID_FILE"

# Wait for server to start and verify
sleep 2
if ! check_port; then
    log_error "Server failed to start on port $CURSOR_PORT"
    exit 1
fi

log_info "Server started successfully on port $CURSOR_PORT"
