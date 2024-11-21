#!/bin/bash

# Configuration
WORKSPACE_ROOT="/workspaces/recruiterlangflow"
CURSOR_SERVER_DIR="/home/codeany/.cursor-server"
CURSOR_VERSION="Stable-001668006cc714afd397f4ef0d52862f5a095530"
CURSOR_PORT="63000"
PID_FILE="/tmp/cursor-server.pid"
LOG_DIR="$WORKSPACE_ROOT/.vscode/logs"
LOG_FILE="$LOG_DIR/cursor-server.log"

# Create log directory
mkdir -p "$LOG_DIR"

# Logging functions
log_info() {
    printf "[INFO] %s - %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1" | tee -a "$LOG_FILE"
}

log_error() {
    printf "[ERROR] %s - %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$1" >&2 | tee -a "$LOG_FILE"
}

# Check if server is running
check_server() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p "$PID" > /dev/null 2>&1; then
            return 0
        else
            rm "$PID_FILE"
        fi
    fi
    return 1
}

# Simplified port check
check_port() {
    netstat -tuln | grep -q ":$CURSOR_PORT "
    return $?
}

# Check prerequisites
check_prerequisites() {
    if [ ! -d "$CURSOR_SERVER_DIR" ]; then
        log_error "Cursor server directory not found"
        exit 1
    fi
    if [ ! -d "$WORKSPACE_ROOT" ]; then
        log_error "Workspace root not found"
        exit 1
    fi
} 