#!/bin/bash

# Correct path to your Cloud_project directory
PROJECT_PATH="/Users/oskar/Documents/Cloud_project"

echo "Script started..."

# Navigate to the Cloud_project directory
cd "$PROJECT_PATH" || { echo "Failed to change directory to $PROJECT_PATH. Exiting script."; exit 1; }

echo "Navigated to project directory, listing files in images directory:"
ls images/

# Loop through each image file in the images directory
for image in images/*; do
    # Check if the file is an image
    if [[ $(file --mime-type -b "$image") == image/* ]]; then
        # Extract the base filename without the extension
        filename=$(basename -- "$image")

        echo "Processing $filename:"

        # Annotate the image with Ollama using the llava:34b model and output the annotation to the terminal
        description=$(ollama run llava:34b "describe $image")
        echo "Description: $description"
        echo ""  # Adds a newline for better readability
    else
        echo "$filename is not an image file."
    fi
done

echo "Script completed."
