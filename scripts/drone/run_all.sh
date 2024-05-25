#!/bin/bash

echo "Connecting to the WiFi..."
./connect_to_wifi.sh

echo "Synchronizing time..."
./sync_time.sh

echo "Copying files and updating metadata..."
./copy_files_and_update_metadata.sh

echo "Creating the database..."
./create_db.sh

echo "Logging Wi-Fi signal data..."
./log_wifi_signal.sh

