#!/bin/bash

# Variables
DB_NAME="wifi_signal_log.db"
TABLE_NAME="wifi_signal"
RASPBERRY_PI_USER="emli"
RASPBERRY_PI_HOST="192.168.10.1"
RASPBERRY_PI_PASSWORD="raspberry"

# Log Wi-Fi signal strength and timestamp
log_signal() {
    while true; do
        # Get the current Wi-Fi signal strength
        SIGNAL_STRENGTH=$(airport -I | grep -i "agrCtlRSSI" | awk '{print $2}')
        TIMESTAMP=$(date +%s)

        # Insert the data into the SQLite database
        sqlite3 ${DB_NAME} "INSERT INTO ${TABLE_NAME} (timestamp, signal_strength) VALUES (${TIMESTAMP}, ${SIGNAL_STRENGTH});"

        echo "Logged Wi-Fi signal data at $(date)"

        # Sleep for a while before logging again
        sleep 10
    done
}

# Start logging Wi-Fi signal
log_signal

