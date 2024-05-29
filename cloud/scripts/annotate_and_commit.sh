#!/bin/bash

# Define the path to your project directory
PROJECT_PATH="/Users/oskar/Documents/Cloud_project/cloud"

echo "Script started..."
cd "$PROJECT_PATH" || { echo "Failed to change directory to $PROJECT_PATH. Exiting script."; exit 1; }

echo "Navigating to project directory, listing files in images directory:"
ls images/

# Recursively find and update all JSON files in the images directory and subdirectories
find images/ -type f -name "*.json" -print0 | while IFS= read -r -d $'\0' json_file; do
    filename=$(basename -- "$json_file")
    directory=$(dirname "$json_file")
    
    echo "Processing JSON file: $filename in directory $directory:"

    # Update the JSON file with the new annotation directly
    jq '.Annotation = {"Source": "Ollama:7b", "Test": "OLLAMA PLACEHOLDER."}' "$json_file" > "${json_file}.tmp" && mv "${json_file}.tmp" "$json_file"

    echo "Updated JSON for $filename with new annotation."
done

echo "Deleting all image files..."

# Now delete all image files in the images directory and subdirectories
find images/ -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) -exec rm {} \;

echo "All image files have been deleted, only JSON files remain."

# Adding changes to git
echo "Adding changes to Git..."
git add .

# Committing changes to git
echo "Committing changes..."
git commit -m "Updated JSON files and removed image files"

# Pushing changes to GitHub
echo "Pushing changes to GitHub..."
git push origin master

echo "Script completed."
