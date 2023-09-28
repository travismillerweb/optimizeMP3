#!/bin/bash

# The parent folder containing the subdirectories
PARENT_FOLDER=.

# Loop over all subdirectories in the parent folder
for folder in "$PARENT_FOLDER"/*20*; do
  if [ -d "$folder" ]; then
    echo "Processing folder: $folder"

    # Loop over all subdirectories in the current folder
    for subfolder in "$folder"/*/; do
      if [ -d "$subfolder" ]; then
        echo "Processing subfolder: $subfolder"

        # Show total size of current directory
        echo "Total size in $subfolder:"
        du -sh "$subfolder"

        # Find and list all MP3 files
        mp3_files=$(find "$subfolder" -maxdepth 1 -type f -iname "*.mp3" -exec du -sh {} \;)

        if [ -n "$mp3_files" ]; then
          echo "MP3 files  in $subfolder:"
          echo "$mp3_files"
        else
          echo "No MP3 files in $subfolder"
        fi

        # Convert all MP3 files in the current and subdirectories to 64 kbps VBR quality
        echo "Converting MP3 files in $subfolder..."
        for f in "$subfolder"/*.mp3; do
          if [ -f "$f" ]; then
            lame -b 64 -h -V 6 "$f" tmp && mv tmp "$f"
          else
            echo "Skipping non-existent file: $f"
          fi
        done
      else
        echo "Skipping non-existent subfolder: $subfolder"
      fi
    done
  else
    echo "Skipping non-existent folder: $folder"
  fi
done
