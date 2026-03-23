#!/usr/bin/env python3
import sys
import os
import hashlib
from datetime import datetime

SUBMISSION_DIR = "submissions"
LOG_FILE = "submission_log.txt"
LOGIN_FILE = "login_attempts.txt"
MAX_SIZE = 5 * 1024 * 1024  # 5MB

os.makedirs(SUBMISSION_DIR, exist_ok=True)
for f in [LOG_FILE, LOGIN_FILE]:
    open(f, "a").close()

def record_event(message):
    with open(LOG_FILE, "a") as f:
        f.write(f"{datetime.now()} - {message}\n")

def file_hash(file_path):
    hasher = hashlib.sha256()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hasher.update(chunk)
    return hasher.hexdigest()

def submit(student_id, file_name, file_path):
    if not os.path.isfile(file_path):
        print("Error: File not found.")
        return

    if os.path.getsize(file_path) > MAX_SIZE:
        print("Error: File exceeds 5MB limit.")
        return

    ext = file_name.split('.')[-1]
    if ext not in ["pdf", "docx"]:
        print("Error: Invalid file type.")
        return

    # Check duplicates
    for existing in os.listdir(SUBMISSION_DIR):
        existing_path = os.path.join(SUBMISSION_DIR, existing)
        if existing == file_name and file_hash(existing_path) == file_hash(file_path):
            print("Error: Duplicate submission detected.")
            record_event(f"Duplicate submission rejected: {student_id} {file_name}")
            return

    dest_path = os.path.join(SUBMISSION_DIR, file_name)
    os.system(f"cp '{file_path}' '{dest_path}'")
    print("Submission accepted.")
    record_event(f"Submission accepted: {student_id} {file_name}")

def list_submissions():
    files = os.listdir(SUBMISSION_DIR)
    if not files:
        print("No submissions yet.")
    else:
        for f in files:
            print(f)

# Login handling with persistent attempts
def load_attempts():
    attempts = {}
    if os.path.exists(LOGIN_FILE):
        with open(LOGIN_FILE, "r") as f:
            for line in f:
                user, count = line.strip().split(",")
                attempts[user] = int(count)
    return attempts

def save_attempts(attempts):
    with open(LOGIN_FILE, "w") as f:
        for user, count in attempts.items():
            f.write(f"{user},{count}\n")

def login(username, password):
    attempts = load_attempts()
    if username not in attempts:
        attempts[username] = 0

    if password == "pass":  # demo password
        print("Login successful.")
        attempts[username] = 0
        record_event(f"Successful login: {username}")
    else:
        attempts[username] += 1
        print(f"Login failed. Attempt {attempts[username]}")
        record_event(f"Failed login attempt: {username}")
        if attempts[username] >= 3:
            print("Account locked due to 3 failed attempts.")
            record_event(f"Account locked: {username}")

    save_attempts(attempts)

if __name__ == "__main__":
    command = sys.argv[1]

    if command == "submit":
        student_id = sys.argv[2]
        file_name = sys.argv[3]
        file_path = sys.argv[4]
        submit(student_id, file_name, file_path)
    elif command == "list":
        list_submissions()
    elif command == "login":
        username = sys.argv[2]
        password = sys.argv[3]
        login(username, password)