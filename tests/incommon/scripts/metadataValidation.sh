#!/bin/bash

# Function to check metadata validity window (validUntil attribute)
check_validity_window() {
  local file="$1"

  # Check if the file exists
  if [ ! -f "$file" ]; then
    echo "File $file does not exist."
    exit 1
  fi

  # echo "Verifying metadata validity window in file: $file"

  # Extract a specific element/attribute value
  valid_until_timestamp_string=$(grep -oP '(Entity|Entities)Descriptor[^>]*\svalidUntil="\K[^"]*' "$file")

  # Extract the date portion from the date string (YYYY-MM-DD)
  valid_until_date=$(echo "$valid_until_timestamp_string" | cut -d'T' -f1)

  # Get the current date in YYYY-MM-DD format
  current_date=$(date +%Y-%m-%d)

  # Calculate the date for two weeks in the future
  future_date=$(date -d "$current_date + 14 days" +%Y-%m-%d)

  # Compare the date portion of the date string with the future date
  if [ "$valid_until_date" != "$future_date" ]; then
    echo "[ERROR] $file"
    echo "[ERROR] validUntil date $valid_until_date is not 2 weeks in the future from $current_date"
    exit 1
  fi
}
