#!/bin/bash

# Variables
RASPBERRY_PI_USER="emli"
RASPBERRY_PI_HOST="192.168.10.1"
RASPBERRY_PI_PASSWORD="raspberry"
RASPBERRY_PI_PICTURES_DIR="/home/emli/pictures/"
LOCAL_CLOUD_DIR="/Users/oskar/Documents/Cloud_project/cloud/images/"
DRONE_ID="WILDDRONE-001"

# Ensure the local directory exists
mkdir -p "${LOCAL_CLOUD_DIR}"

# Function to copy files and update metadata
copy_files() {
    # List files in the remote directory
    sshpass -p "${RASPBERRY_PI_PASSWORD}" ssh "${RASPBERRY_PI_USER}@${RASPBERRY_PI_HOST}" "ls ${RASPBERRY_PI_PICTURES_DIR}*/*.jpg" | while read -r FILE; do
        # Extract the directory and file name
        DIR_NAME=$(dirname "${FILE}")
        BASE_NAME=$(basename "${FILE}")

        # Create the corresponding local directory
        LOCAL_DIR="${LOCAL_CLOUD_DIR}$(basename ${DIR_NAME})"
        mkdir -p "${LOCAL_DIR}"

        # Check if the file already exists locally
        if [ -f "${LOCAL_DIR}/${BASE_NAME}" ]; then
            echo "File ${LOCAL_DIR}/${BASE_NAME} already exists, skipping."
        else
            # Copy the file to the local directory
            sshpass -p "${RASPBERRY_PI_PASSWORD}" scp "${RASPBERRY_PI_USER}@${RASPBERRY_PI_HOST}:${FILE}" "${LOCAL_DIR}/"
            if [ $? -eq 0 ]; then
                echo "Copied ${FILE} to ${LOCAL_DIR}/"

                # Update metadata JSON file
                JSON_FILE="${DIR_NAME}/${BASE_NAME%.jpg}.json"
                EPOCH_TIME=$(date +%s.%3N)
                sshpass -p "${RASPBERRY_PI_PASSWORD}" ssh "${RASPBERRY_PI_USER}@${RASPBERRY_PI_HOST}" "sudo chmod 666 ${JSON_FILE} && sudo jq --arg drone_id '${DRONE_ID}' --arg epoch '${EPOCH_TIME}' '.\"Drone Copy\" = {\"Drone ID\": \$drone_id, \"Seconds Epoch\": \$epoch}' ${JSON_FILE} > ${JSON_FILE}.tmp && sudo mv ${JSON_FILE}.tmp ${JSON_FILE} && sudo chmod 644 ${JSON_FILE}"
                if [ $? -eq 0 ]; then
                    echo "Updated metadata for ${JSON_FILE}"
                else
                    echo "Failed to update metadata for ${JSON_FILE}"
                fi
            else
                echo "Failed to copy ${FILE}"
            fi
        fi
    done
}

# Call the function to copy files and update metadata
copy_files

echo "All files copied and metadata updated."

