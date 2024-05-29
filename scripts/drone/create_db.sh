#!/bin/bash

# Database file path
DB_FILE="/Users/oskar/Documents/Cloud_project/cloud/wifi_signal.db"

# Check if the database file exists
if [ ! -f "${DB_FILE}" ]; then
    # Create the database and table
    sqlite3 "${DB_FILE}" <<EOF
    CREATE TABLE wifi_signal_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        signal_level INTEGER NOT NULL,
        link_quality INTEGER NOT NULL
    );
EOF
    if [ $? -eq 0 ]; then
        echo "Database and table created successfully."
    else
        echo "Failed to create database and table."
    fi
else
    echo "Database already exists. Skipping creation."
fi

