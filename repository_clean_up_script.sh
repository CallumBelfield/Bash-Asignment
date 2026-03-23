#!/bin/bash


echo "Preparing clean submission folder..."


rm -f submission_log.txt scheduler_log.txt system_monitor_log.txt


if [ -d "ArchiveLogs" ]; then
    rm -rf ArchiveLogs/*.gz
    rmdir ArchiveLogs 2>/dev/null
fi


rm -rf submissions
rm -f completed_jobs.txt job_queue.txt login_attempts.txt


rm -f test.log test.pdf

echo "Cleanup complete. Only essential scripts and documentation remain."