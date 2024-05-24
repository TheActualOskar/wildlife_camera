#!/bin/bash

# Get trigger argument
TRIGGER=$1

# Get the current date and time
CURRENT_DATE=$(date +"%Y-%m-%d")
CURRENT_TIME=$(date +"%H%M%S_%3N")

# Create the directory named by the current date if it doesn't exist
SAVE_DIR="/home/emli/pictures/$CURRENT_DATE"
mkdir -p "$SAVE_DIR"

# Define the file path with the specified filename format
FILE_PATH="$SAVE_DIR/${CURRENT_TIME}.jpg"

# Take a picture using the Raspberry Pi camera and save it to the file path
rpicam-still -o "$FILE_PATH" -t 0.45

# Print a message to indicate the picture was taken
echo "Picture taken and saved as: $FILE_PATH"
echo "generating metadata"

./generate_metadata.sh "$CURRENT_DATE" "$CURRENT_TIME" "$TRIGGER"

./log_handler.sh "$TRIGGER have triggered a photo"
