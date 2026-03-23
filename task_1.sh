#!/bin/bash

SYS_LOG="system_monitor_log.txt"
LOG_ARCHIVE="ArchiveLogs"

record_event() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$SYS_LOG"
}

check_critical() {
    case "$1" in
        1|2|3|4|5)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

cpu_mem_status() {
    echo "CPU Stats:"
    top -bn1 | grep "Cpu(s)"

    echo "RAM Usage:"
    free -h

    record_event "Checked CPU and RAM usage"
}

high_mem_procs() {
    echo "Top 10 RAM-heavy Processes:"
    ps -eo pid,user,%cpu,%mem --sort=-%mem | head -11
    record_event "Viewed top 10 RAM-heavy processes"
}

terminate_process() {
    read -p "Enter PID to terminate: " process_id

    if check_critical "$process_id"; then
        echo "Cannot terminate critical system process!"
        record_event "Attempted to kill critical process $process_id"
        return
    fi

    read -p "Are you sure you want to terminate process $process_id? (Y/N): " confirm
    if [[ "${confirm,,}" == "y" ]]; then
        kill "$process_id" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "Process terminated successfully."
            record_event "Killed process $process_id"
        else
            echo "Failed to terminate process."
            record_event "Failed to kill process $process_id"
        fi
    else
        echo "Termination cancelled."
        record_event "Cancelled termination of process $process_id"
    fi
}

show_dir_size() {
    read -p "Enter directory path: " directory_path

    if [ -d "$directory_path" ]; then
        du -sh "$directory_path"
        record_event "Checked disk usage for $directory_path"
    else
        echo "Directory does not exist."
        record_event "Invalid directory check attempted: $directory_path"
    fi
}

archive_large_logs() {
    mkdir -p "$LOG_ARCHIVE"

    find . -type f -name "*.log" -size +50M | while read file; do
        timestamp=$(date '+%Y%m%d%H%M%S')
        filename=$(basename "$file")
        gzip -c "$file" > "$LOG_ARCHIVE/${filename}_${timestamp}.gz"

        if [ $? -eq 0 ]; then
            echo "Archived: $file"
            record_event "Archived log file $file"
        fi
    done

    archive_size=$(du -sm "$LOG_ARCHIVE" | cut -f1)
    if [ "$archive_size" -gt 1024 ]; then
        echo "Warning: Archive directory exceeds 1GB."
        record_event "Archive directory exceeded 1GB"
    fi
}

while true; do
    echo ""
    echo "DATA CENTER SYSTEM"
    echo "1. Display CPU & RAM Usage"
    echo "2. Show Top 10 RAM-heavy Processes"
    echo "3. Terminate a Process"
    echo "4. Check Disk Usage"
    echo "5. Archive Large Log Files"
    echo "6. Exit"
    echo "- - - - - - - - - -"

    read -p "Choose an option: " user_choice

    case $user_choice in
        1) cpu_mem_status ;;
        2) high_mem_procs ;;
        3) terminate_process ;;
        4) show_dir_size ;;
        5) archive_large_logs ;;
        6)
            read -p "Please confirm (Y/N): " exit_confirm
            if [[ "${exit_confirm,,}" == "y" ]]; then
                echo "Exiting..."
                record_event "System exited by user"
                exit 0
            fi
            ;;
        *)
            echo "Invalid option. Please select a valid menu number."
            ;;
    esac
done
