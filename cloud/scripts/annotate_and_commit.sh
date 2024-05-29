#!/bin/bash

# Define the path to your project directory
PROJECT_PATH="/home/baumann/Downloads/Test/wildlife_camera/cloud"

echo "Script started..."
cd "$PROJECT_PATH" || { echo "Failed to change directory to $PROJECT_PATH. Exiting script."; exit 1; }

# Directory where annotated JSON files will be stored before commit
ANNOTATED_JSON_DIR="cloud/annotated_json"
mkdir -p $ANNOTATED_JSON_DIR

echo "Navigated to project directory, listing files in images directory:"
ls images/

# Loop through each image file in the images directory
for image in images/*; do
    if [[ $(file --mime-type -b "$image") == image/* ]]; then
        filename=$(basename -- "$image")
        base="${filename%.*}"
        
        echo "Processing $filename:"
        
        # Annotate the image and extract the description
        description=$(ollama run llava:13b "describe $image")
        
        # Update the JSON file with the annotation
        json_file="json/${base}.json"
        
        if [[ -f "$json_file" ]]; then
            # If the JSON file exists, update it
            jq --arg desc "$description" --arg source "Ollama:13b" \
                '.Annotation = {"Source": $source, "Test": $desc}' "$json_file" > "$ANNOTATED_JSON_DIR/${base}.json"
        else
            # If the JSON file does not exist, create it
            echo "{\"Annotation\": {\"Source\": \"Ollama:13b\", \"Test\": \"$description\"}}" > "$ANNOTATED_JSON_DIR/${base}.json"
        fi
        
        echo "Updated JSON for $filename with new description."
    else
        echo "$filename is not an image file."
    fi
done

# Commit updated JSON files to Git
cd $ANNOTATED_JSON_DIR
git add .
git commit -m "Batch commit of annotated JSON files"
git push origin master  # Change to 'master' if your branch is named 'master'

echo "Script completed."

