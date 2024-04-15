#!/bin/bash

# Ask the user for the file name
read -p "Enter the file name (without extension): " filename

# Add .inp extension to the filename
filename="$filename.inp"

# Check if the file exists in the current directory
if [ ! -f "$filename" ]; then
    echo "File not found in the current directory."
    exit 1
fi

echo "File found: $filename"

# Ask the user for the line number
read -p "Enter the line number: " linenum

# Check if the line number is valid
total_lines=$(wc -l < "$filename")
if [ "$linenum" -le 0 ] || [ "$linenum" -gt "$total_lines" ]; then
    echo "Invalid line number. The file has $total_lines lines."
    exit 1
fi

echo "Valid line number: $linenum"

# Print the line before the valid line number
sed -n "$((linenum-1))p" "$filename"

# Print the valid line number in italics
echo "\e[3m$(sed -n "${linenum}p" "$filename")\e[0m"

# Print the line after the valid line number
sed -n "$((linenum+1))p" "$filename"
