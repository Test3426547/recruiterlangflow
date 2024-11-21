#!/bin/sh

source "$(dirname "$0")/cursor-utils.sh"

show_menu() {
    clear
    echo "=== Cursor Server Management ==="
    echo "1. Start Server"
    echo "2. Stop Server"
    echo "3. Restart Server"
    echo "4. Check Status"
    echo "5. View Logs"
    echo "6. Clear Logs"
    echo "0. Exit"
    echo "=========================="
}

handle_choice() {
    case "$1" in
        1) "$(dirname "$0")/cursor-server.sh" ;;
        2) "$(dirname "$0")/cursor-stop.sh" ;;
        3) "$(dirname "$0")/cursor-restart.sh" ;;
        4) "$(dirname "$0")/cursor-status.sh" ;;
        5) less "$LOG_FILE" ;;
        6) 
            echo "" > "$LOG_FILE"
            log_info "Logs cleared"
            ;;
        0) exit 0 ;;
        *) log_error "Invalid choice" ;;
    esac
    echo "Press Enter to continue..."
    read -r
}

# Main loop
while true; do
    show_menu
    echo "Enter your choice: "
    read -r choice
    handle_choice "$choice"
done 