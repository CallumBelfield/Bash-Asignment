#!/bin/bash

while true; do
    echo ""
    echo "SECURE SUBMISSION SYSTEM "
    echo "1. Submit Assignment"
    echo "2. List Submitted Assignments"
    echo "3. Simulate Login"
    echo "4. Exit"
    echo "- - - - - - - - - -"
    read -p "Choose option: " user_choice

    case $user_choice in
        1)
            read -p "Enter Student ID: " student_id
            read -p "Enter file name (with extension): " file_name
            read -p "Enter file path: " file_path
            python3 submission.py submit "$student_id" "$file_name" "$file_path"
            ;;
        2)
            python3 submission.py list
            ;;
        3)
            read -p "Enter username: " username
            read -s -p "Enter password: " password
            echo
            python3 submission.py login "$username" "$password"
            ;;
        4)
            read -p "Please confirm (Y/N): " confirm
            if [[ "${confirm,,}" == "y" ]]; then
                echo "Exiting..."
                exit 0
            fi
            ;;
        *)
            echo "Invalid selection. Please choose a valid menu number."
            ;;
    esac
done