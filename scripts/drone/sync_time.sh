#!/bin/bash

# Define the password for the Raspberry Pi's user
PI_PASSWORD="raspberry"

# Function to synchronize time
function sync_time {
    echo "Synchronizing time with the Raspberry Pi..."
    # Get the current UTC time from the MacBook
    current_time=$(date -u +"%Y-%m-%d %H:%M:%S")
    # Using sshpass and SSH to set the Raspberry Pi's date to match the MacBook's UTC date
    sshpass -p "$PI_PASSWORD" ssh emli@192.168.10.1 "echo $PI_PASSWORD | sudo -S date -u -s \"$current_time\""
    if [ $? -eq 0 ]; then
        echo "Time synchronized successfully."
        echo "Current time on the Raspberry Pi after synchronization:"
        sshpass -p "$PI_PASSWORD" ssh emli@192.168.10.1 "date"
    else
        echo "Failed to synchronize time."
    fi
}

# Main logic
sync_time

