#!/bin/bash

DEVICE=${1:-"/dev/ttyACM0"}
MQTT_HOST=${2:-"localhost"}
MQTT_TOPIC=${3:-"rain_sensor"}
MQTT_USER=${4:-"emli"}
MQTT_PASSWORD=${5:-"raspberry"}

publish_message() {
    mosquitto_pub -h $MQTT_HOST -t $MQTT_TOPIC -m "raining" -u $MQTT_USER -P $MQTT_PASSWORD
}

# Flush the serial input buffer
stty -F $DEVICE 115200 raw -echo
cat < $DEVICE > /dev/null 2>&1 & PID=$!
sleep 0.1
kill $PID

# Loop and continuously read from /dev/ttyACM0
while true; do
    # Read JSON data from /dev/ttyACM0
    WIPER_JSON=$(head -1 $DEVICE)
    echo "$WIPER_JSON"
    
    # If statement to check for json_error or angle_error
    if [[ "$WIPER_JSON" != *"json_error"* && "$WIPER_JSON" != *"angle_error"* ]]; then
        # Extract rain_detect from the JSON data
        RAIN_DETECTED=$(echo "$WIPER_JSON" | jq -r '.rain_detect')
    fi

    # Check if RAIN_DETECTED is equal to 1 (it is raining)
    if [ "$RAIN_DETECTED" -eq 1 ]; then
        # Publish MQTT message
        publish_message
	/home/emli/scripts/log_handler.sh "Raining, starting to wipe"
        sleep 5
    fi

    # Sleep for 1 second
    sleep 1
done
