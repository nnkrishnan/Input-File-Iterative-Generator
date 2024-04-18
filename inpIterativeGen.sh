#!/bin/bash


bold=$(tput bold)
normal=$(tput sgr0)
underlineStart=$(tput smul)
underlineEnd=$(tput rmul)
# Check if bc is installed
if  ! [ -x "$(command -v bc)" ]; then
    echo "Error: bc is not installed. Please install it to proceed."
    echo "If you are using Debian or Ubuntu try:"
    echo "sudo apt-get install bc"
    exit 1
fi

# Function to calculate precision of a floating-point number
get_precision() {
    local num="$1"
    local decimal_part="${num#*.}"
    local precision=${#decimal_part}
    echo "$precision"
}
# Get the list of .inp files in the current directory
files=$(find . -maxdepth 1 -type f -name "*.inp" -exec basename {} \;)
# Check if the current directory has *inp files
if [ -z "$files" ]; then
    echo "No .inp files found in the current directory. Exiting..."
    exit 1
fi

# Print the input files found
echo "The following .inp files were found in the current directory"
printf "\t%s\n" "${files}"
# Ask the user for the file name
read -p "Enter the file name (without extension): " filename

# Add .inp extension to the filename
filename_ext="$filename.inp"

# Check if the file exists in the current directory
if [ ! -f "$filename_ext" ]; then
    echo "File not found in the current directory."
    exit 1
fi

printf "\tFile found: $filename_ext\n"
printf "\tThe file contains $(wc -l < "$filename_ext") lines\n"
# Ask the user for the line number
read -p "Enter the line number: " linenum

# Check if the line number is valid
total_lines=$(wc -l < "$filename_ext")
if [ "$linenum" -le 0 ] || [ "$linenum" -gt "$total_lines" ]; then
    echo "Invalid line number. The file has $total_lines lines."
    exit 1
fi

printf "$linenum is a valid line number\n"

# Print the line before the selected line number
if ! [ "$linenum" -eq 1 ]; then
printf "\t \033[2m%s\033[0m\n" "$(sed -n "$((linenum-1))p" "$filename_ext")"
fi
# Print the selected line in italics
printf  "\t \033[1m%s\033[0m\n" "$(sed -n "$((linenum))p" "$filename_ext")"

if ! [ "$linenum" -eq "$(wc -l < "$filename_ext")" ]; then
# Print the line after the selected line number
printf  "\t \033[2m$(sed -n "$((linenum+1))p" "$filename_ext")\033[0m"
fi

echo "  "


# Ask the user for the new text with ^i
echo -n "Enter the new text with ${underlineStart}^i${underlineEnd}: "
read new_text

# Check if the new text contains ^i using wildcard matching
if ! printf "$new_text" | grep -q "\^i"; then
    printf "Error: The new text must contain ^i.\n"
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

# Compute the precision. Precision is neccessory for accuratly writing values
precision=$(get_precision "$step_size")
if (( $(get_precision "$max_i") > precision )); then 
    precision=$(get_precision "$max_i")
fi

if (( $(get_precision "$initial_i") > precision )); then  
    precision=$(get_precision "$initial_i") 
fi

# Generate file copies with appended file names
i=$(printf "%.*f" "$precision" "$initial_i")
while [ "$(echo "$i <= $max_i" | bc)" -eq 1 ]; do
    # Format the file name with one decimal place
    new_filename=$(printf "%s-%.*f" "$filename" "$precision" "$i")
    new_filename_ext="$new_filename.inp"
    cp "$filename_ext" "$new_filename_ext"
    echo "Copied $filename_ext to $new_filename_ext"
    
    # Replace ^i with the value of 'i' in the new text
    new_text_i=$(echo "$new_text" | sed "s/\^i/$i/g")
    sed -i "${linenum}s/.*/$new_text_i/" "$new_filename_ext"
    echo "Edited $new_filename_ext"
    i=$(echo "$i + $step_size" | bc)
    i=$(printf "%.*f" "$precision" "$i")
done
