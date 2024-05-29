#!/bin/bash

# Database file path
DB_FILE="/Users/oskar/Documents/Cloud_project/cloud/images/wifi_signal.db"

# Function to log Wi-Fi signal data
log_wifi_signal() {
    while true; do
        TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
        SIGNAL_LEVEL=$(airport -I | grep -i "agrCtlRSSI" | awk '{print $2}')
        LINK_QUALITY=$(airport -I | grep -i "agrCtlNoise" | awk '{print $2}')

        # Insert the data into the database
        sqlite3 "${DB_FILE}" <<EOF
        INSERT INTO wifi_signal_log (timestamp, signal_level, link_quality) VALUES ('${TIMESTAMP}', '${SIGNAL_LEVEL}', '${LINK_QUALITY}');
EOF

        if [ $? -eq 0 ]; then
            echo "Logged WiFi signal data at ${TIMESTAMP}"
        else
            echo "Failed to log WiFi signal data"
        fi

        # Sleep for a specified interval before logging again (e.g., 60 seconds)
        sleep 60
    done
}

# Call the function to log Wi-Fi signal data
log_wifi_signal

