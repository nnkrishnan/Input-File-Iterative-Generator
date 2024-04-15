#!/bin/bash

# Check if bc is installed
if  ![ -x "$(command -v bc)" ]; then
    echo "Error: bc is not installed. Please install it to proceed."
    echo "If you are using Debian or Ubuntu try:"
    echo "sudo apt-get install bc"
    exit 1
fi

# Ask the user for the file name
read -p "Enter the file name (without extension): " filename

# Add .inp extension to the filename
filename_ext="$filename.inp"

# Check if the file exists in the current directory
if [ ! -f "$filename_ext" ]; then
    echo "File not found in the current directory."
    exit 1
fi

echo "File found: $filename_ext"

# Ask the user for the line number
read -p "Enter the line number: " linenum

# Check if the line number is valid
total_lines=$(wc -l < "$filename_ext")
if [ "$linenum" -le 0 ] || [ "$linenum" -gt "$total_lines" ]; then
    echo "Invalid line number. The file has $total_lines lines."
    exit 1
fi

echo "Valid line number: $linenum"

# Print the line before the valid line number
sed -n "$((linenum-1))p" "$filename_ext"

# Print the valid line number in italics
echo "\e[3m$(sed -n "${linenum}p" "$filename_ext")\e[0m"

# Print the line after the valid line number
sed -n "$((linenum+1))p" "$filename_ext"


echo "  "


# Ask the user for the new text with ^i
read -p "Enter the new text with ^i: " new_text

# Check if the new text contains ^i using wildcard matching
if ! echo "$new_text" | grep -q "\^i"; then
    echo "Error: The new text must contain ^i."
    exit 1
fi

# Ask for initial i, max i, and step size
read -p "Enter the initial i: " initial_i
read -p "Enter the max i: " max_i
read -p "Enter the step size: " step_size

# Check if step size is non-zero
if [ "$(echo "$step_size > 0" | bc)" -eq 0 ]; then
    echo "Error: Step size cannot be zero."
    exit 1
fi

# Generate file copies with appended file names
i=$(printf "%.1f" "$initial_i")
while [ "$(echo "$i <= $max_i" | bc)" -eq 1 ]; do
    # Format the file name with one decimal place
    new_filename=$(printf "%s-%.1f" "$filename" "$i")
    new_filename_ext="$new_filename.inp"
    cp "$filename_ext" "$new_filename_ext"
    echo "Copied $filename_ext to $new_filename_ext"
    
    # Replace ^i with the value of 'i' in the new text
    new_text_i=$(echo "$new_text" | sed "s/\^i/$i/g")
    sed -i "${linenum}s/.*/$new_text_i/" "$new_filename_ext"
    
    i=$(echo "$i + $step_size" | bc)
    i=$(printf "%.1f" "$i")
done
