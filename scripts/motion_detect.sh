#!/bin/bash

# Get the current date and time
CURRENT_DATE=$(date +"%Y-%m-%d")
CURRENT_TIME=$(date +"%H%M%S_%3N")

# Create the directory named by the current date if it doesn't exist
SAVE_DIR="/home/emli/temp_pictures/$CURRENT_DATE"
mkdir -p "$SAVE_DIR"

# Paths to the images
IMAGE1_PATH="$SAVE_DIR/$CURRENT_TIME.jpg"
rpicam-still -o "$IMAGE1_PATH" -t  0.45

sleep 5

IMAGE2_PATH="$SAVE_DIR/$CURRENT_TIME.jpg"
rpicam-still -o "$IMAGE2_PATH" -t 0.45

# Path to the Python script
PYTHON_SCRIPT="/home/emli/scripts/motion_detect.py"

# Check if both images exist
if [[ ! -f "$IMAGE1_PATH" || ! -f "$IMAGE2_PATH" ]]; then
    echo "One or both image files do not exist."
    exit 1
fi

# Run the Python script and capture the output
OUTPUT=$(python3 "$PYTHON_SCRIPT" "$IMAGE1_PATH" "$IMAGE2_PATH")

# Check for motion detection in the output
if echo "$OUTPUT" | grep -q "Motion detected"; then
    echo "Motion detected"
    # Add any additional actions you want to perform when motion is detecte
	cp $IMAGE2_PATH /home/emli/pictures/$CURRENT_DATE/
        /home/emli/scripts/generate_metadata.sh "$CURRENT_DATE" "$CURRENT_TIME" motion
	/home/emli/scripts/log_handler.sh "Motion was detected"
	rm -rf /home/emli/temp_pictures/*
else
	
    echo "No motion detected"
	rm -rf /home/emli/temp_pictures/*
	

fi
