#!/bin/bash

job_queue_file="job_queue.txt"
completed_jobs_file="completed_jobs.txt"
scheduler_log_file="scheduler_log.txt"

touch "$job_queue_file" "$completed_jobs_file" "$scheduler_log_file"

record_event() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$scheduler_log_file"
}

add_job() {
    read -p "Enter Student ID: " student_id
    read -p "Enter Job Name: " job_name
    read -p "Enter Execution Time (seconds): " execution_time
    read -p "Enter Priority (1-10): " priority
    echo "$student_id,$job_name,$execution_time,$priority" >> "$job_queue_file"
    record_event "Job submitted: $student_id $job_name Priority:$priority"
    echo "Job successfully added"
}

show_pending_jobs() {
    echo "Current Pending Jobs:"
    cat "$job_queue_file"
}

run_round_robin() {
    quantum=5
    while IFS=, read -r student_id job_name execution_time priority; do
        remaining=$execution_time
        while [ $remaining -gt 0 ]; do
            run=$(( remaining < quantum ? remaining : quantum ))
            sleep 1
            remaining=$((remaining - run))
        done
        echo "$student_id,$job_name completed" >> "$completed_jobs_file"
        record_event "Job executed (Round Robin): $student_id $job_name"
    done < "$job_queue_file"
    > "$job_queue_file"
}

run_priority_schedule() {
    sort -t, -k4 -nr "$job_queue_file" | while IFS=, read -r student_id job_name execution_time priority; do
        sleep 1
        echo "$student_id,$job_name completed" >> "$completed_jobs_file"
        record_event "Job executed (Priority Scheduling): $student_id $job_name"
    done
    > "$job_queue_file"
}

show_completed_jobs() {
    echo "Jobs Completed:"
    cat "$completed_jobs_file"
}

while true; do
    echo ""
    echo "JOB SCHEDULER"
    echo "1. View Pending Jobs"
    echo "2. Submit Job"
    echo "3. Run Round Robin"
    echo "4. Run Priority Scheduling"
    echo "5. View Completed Jobs"
    echo "6. Exit"
    echo "- - - - - - - - - -"
    read -p "Choose option: " user_choice

    case $user_choice in
        1) show_pending_jobs ;;
        2) add_job ;;
        3) run_round_robin ;;
        4) run_priority_schedule ;;
        5) show_completed_jobs ;;
        6)
            read -p "Please confirm (Y/N): " confirm
            if [[ "${confirm,,}" == "y" ]]; then
                echo "Exiting..."
                record_event "Scheduler exited by user"
                exit 0
            fi
            ;;
        *)
            echo "Invalid selection. Please choose a valid menu number."
            ;;
    esac
done