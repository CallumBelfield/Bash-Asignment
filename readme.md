Tasks:

1. System monitoring and process management
2. Job scheduling for high-performance computing
3. Secure examination submission and access control

The following tasks exclusively use bash and python aligning with assignment guidance.

-------------------------------------------------------------------------------------------------------------------------------

Directory Structure (Clean Repository)

task_2.sh Bash menu for Task 2
task_3_python.py Python script for Task 3
task_3.sh Bash menu for Task 3
task_1.sh Bash system monitor script (Task 1)
repository_clean_up_script.sh Optional cleanup utility
readme.txt Instructions and documentation

Runtime-Generated Files

The following files and directories are automatically created when scripts are executed:

ArchiveLogs/ Created when large logs are archived (Task 1)
submissions/ Stores submitted files (Task 3)
completed_jobs.txt Stores completed jobs (Task 2)
job_queue.txt Stores pending jobs (Task 2)
login_attempts.txt Tracks login attempts (Task 3)
scheduler_log.txt Job scheduler logs (Task 2)
submission_log.txt Submission system logs (Task 3)
system_monitor_log.txt System monitor logs (Task 1)

-------------------------------------------------------------------------------------------------------------------------------

How to Run Scripts

Task 1 – System Monitor

Insert the following into a WSL: Ubuntu supported terminal
./task_1.sh

Use navigation menu in console to complete tests.

Task 2 – Job Scheduler

Insert the following into a WSL: Ubuntu supported terminal
./task_2.sh

Use navigation menu in console to complete tests.

Task 3 – Secure Submission System

Insert the following into a WSL: Ubuntu supported terminal
./task_3.sh

Use navigation menu in console to complete tests.

-------------------------------------------------------------------------------------------------------------------------------

Notes
All log files (*_log.txt) store actions with timestamps.
Large logs in Task 1 are archived in ArchiveLogs/.
Pending and completed jobs are stored in text files for persistence.
Login attempts persist across runs via login_attempts.txt.
Example files test.log and test.pdf are included for testing.

-------------------------------------------------------------------------------------------------------------------------------

DISCLOSURE: Best practice would be to clone this repository to allow changes to be made during testing.
 - Ensure terminal has WSL support otherwise the bash will not be able to execute in terminal.

-------------------------------------------------------------------------------------------------------------------------------

Additional feature added for OCD purposes:
repository_clean_up_script.sh 

run using "./repository_clean_up_script.sh"
-cleans the repositry after testing (created to make the cloned repository clean and ready to be fully tested.)
