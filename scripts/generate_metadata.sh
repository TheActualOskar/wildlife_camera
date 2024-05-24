#!/bin/bash

# Parameters passed from the calling script
CURRENT_DATE=$1
CURRENT_TIME=$2
TRIGGER=$3
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S.%3N%z")

# Convert to seconds since epoch
SECONDS_EPOCH=$(date +"%s.%3N")

# Set the subject distance, exposure time, and ISO values
SUBJECT_DISTANCE="0.5574136009"
EXPOSURE_TIME="1/33"
ISO="200"

# Directory and file paths
SAVE_DIR="/home/emli/pictures/$CURRENT_DATE"
FILE_NAME="${CURRENT_TIME}.jpg"
JSON_NAME="${CURRENT_TIME}.json"
FILE_PATH="$SAVE_DIR/$FILE_NAME"
JSON_PATH="$SAVE_DIR/$JSON_NAME"

# Create the JSON content
JSON_CONTENT=$(cat <<EOF
{
    "File Name": "$FILE_NAME",
    "Create Date": "$TIMESTAMP",
    "Create Seconds Epoch": $SECONDS_EPOCH,
    "Trigger": "$TRIGGER",
    "Subject Distance": $SUBJECT_DISTANCE,
    "Exposure Time": "$EXPOSURE_TIME",
    "ISO": $ISO
}
EOF
)

# Save the JSON content to a file
echo "$JSON_CONTENT" > "$JSON_PATH"

# Print a message to indicate the JSON file was created
echo "JSON metadata created and saved as: $JSON_PATH"
