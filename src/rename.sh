#!/bin/bash

# This script recursively finds directories whose names end in a single digit (1-9)
# preceded by letters (e.g., ch1, sec9, figure3) within the current directory
# and its subdirectories. It renames them by padding the number with a leading
# zero (e.g., ch01, sec09, figure03) so that scripts appear in numerical order.

# Use find to locate directories (-type d)
# -depth processes contents of a directory before the directory itself, crucial for renaming
# -regextype posix-extended enables extended regex syntax
# -regex '.*/[a-zA-Z]+[1-9]$' matches paths ending with /letters+single_digit
# The loop reads each found directory path.
find . -depth -type d -regextype posix-extended -regex '.*/[a-zA-Z]+[1-9]$' | while IFS= read -r dir_path; do
    # Get the directory name itself (e.g., "ch1" from "./stuff/ch1")
    name=$(basename "$dir_path")
    # Get the path to the parent directory (e.g., "./stuff" from "./stuff/ch1")
    parent_dir=$(dirname "$dir_path")

    # Extract the numeric suffix (the last digit)
    # ${string##pattern} removes longest match of pattern from beginning
    num="${name##*[!0-9]}"

    # Extract the alphabetic prefix (everything before the number)
    # ${string%%pattern} removes longest match of pattern from end
    prefix="${name%%$num}"

    # Double-check the pattern just in case find picked up something unexpected,
    # and ensure it's exactly letters followed by a single digit 1-9.
    if [[ "$name" =~ ^[a-zA-Z]+[1-9]$ ]]; then
        # Format the new directory name with a leading zero for the number
        new_name=$(printf "%s%02d" "$prefix" "$num")
        # Construct the full path for the new name
        new_path="$parent_dir/$new_name"

        # Check if the new name is different from the old name (it should be)
        if [ "$dir_path" != "$new_path" ]; then
            # Check if a directory or file with the new name already exists
            # Use -e to check for any type of file/directory existence
            if [ -e "$new_path" ]; then
                # Output warnings to standard error
                echo "Skipping rename: Target '$new_path' already exists." >&2
            else
                # Perform the rename. Use -- to handle names that might start with a hyphen.
                echo "Renaming '$dir_path' to '$new_path'"
                mv -- "$dir_path" "$new_path"
            fi
        fi
    else
         # This case should ideally not be reached due to the find regex, but acts as a safeguard
         echo "Skipping '$dir_path': Name '$name' does not match expected pattern (letters followed by single digit 1-9)." >&2
    fi
done

echo "Finished recursive renaming."


