#!/bin/bash

# Variables
DB_NAME="wifi_signal_log.db"
TABLE_NAME="wifi_signal"

# Create SQLite database and table if they do not exist
sqlite3 ${DB_NAME} "CREATE TABLE IF NOT EXISTS ${TABLE_NAME} (timestamp INTEGER PRIMARY KEY, signal_strength INTEGER);"

echo "Database and table created successfully."

