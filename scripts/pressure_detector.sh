#!/bin/bash

# MQTT topic to subscribe to
MQTT_TOPIC="pressure_detected"

# MQTT broker details (assuming localhost and default port)
MQTT_BROKER="localhost"
MQTT_PORT=1883

# Directory to save pictures
SAVE_DIR="/home/emli/pictures"

# Create the directory if it doesn't exist
mkdir -p "$SAVE_DIR"


# Subscribe to the MQTT topic and execute the take_picture function upon receiving a message
mosquitto_sub -u emli -P raspberry -t "$MQTT_TOPIC" | while read -r MESSAGE
do
    echo "Message received on topic $MQTT_TOPIC: $MESSAGE"
    ./take_photo.sh external
done
