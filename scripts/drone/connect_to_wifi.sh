#!/bin/bash

# Variables
WIFI_SSID="OskarErEnPrut"
WIFI_PASSWORD="emliemli"
NETWORK_DEVICE="wlo1"  # This is typically the WiFi interface on macOS, adjust if necessary

# Function to connect to WiFi
function connect_to_wifi {
    echo "Checking current WiFi network..."
    current_ssid=$(networksetup -getairportnetwork $NETWORK_DEVICE | awk -F ': ' '{print $2}')
    
    if [ "$current_ssid" == "$WIFI_SSID" ]; then
        echo "Already connected to $WIFI_SSID."
    else
        echo "Connecting to $WIFI_SSID..."
        nmcli device wifi connect "$WIFI_SSID" password "$WIFI_PASSWORD" 
        if [ $? -eq 0 ]; then
            echo "Successfully connected to $WIFI_SSID."
        else
            echo "Failed to connect to $WIFI_SSID."
            exit 1
        fi
    fi
}

# Run the connect to WiFi function
connect_to_wifi

