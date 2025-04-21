#!/bin/bash

# This script renames folders named ch1, ch2, ..., ch9
# in the current directory to ch01, ch02, ..., ch09 
# The zero padding ensures that each chapter appears in numerical order.

# Loop through directories matching the pattern 'ch' followed by a single digit (1-9)
for dir in ch[1-9]; do
  # Check if the item is actually a directory and the pattern matched something
  if [ -d "$dir" ]; then
    # Extract the number part from the directory name
    num=$(echo "$dir" | sed 's/ch//')

    # Format the new directory name with a leading zero (e.g., ch01, ch02)
    # The printf command ensures the number is padded with a leading zero if it's less than 10.
    new_name=$(printf "ch%02d" "$num")

    # Check if the new name is different from the old name
    if [ "$dir" != "$new_name" ]; then
      # Check if a directory with the new name already exists
      if [ -e "$new_name" ]; then
        echo "Skipping rename: '$new_name' already exists."
      else
        # Rename the directory
        echo "Renaming '$dir' to '$new_name'"
        mv -- "$dir" "$new_name"
      fi
    fi
  fi
done

echo "Finished renaming."

