#!/bin/bash

while getopts "s:d:p:wm" OPTION
do
    case $OPTION in
    s)
        size=$OPTARG
        ;;
    d)
        destination=$OPTARG
        ;;
    p)
        path=$OPTARG
        ;;
    esac
done

# Create temporary file in the destination directory
temp_icon="$destination/temp_icon.png"

# Convert input to PNG
convert "$path" "$temp_icon"

# Get color of pixel at position 1,1
color=$(convert "$temp_icon" -format '%[hex:p{1,1}]' info:-) 
color=${color:0:6}

# Check if color is black (with proper string comparison)
if [ "$color" = "000000" ]; then
    color="FFFFFF"
fi

# Add # prefix to color
color="#$color"

# Process the image
convert "$path" -thumbnail "${size}x${size}^" -background "$color" -gravity center -extent 1024x1024 "$destination/icon.png"

# Clean up
rm -f "$temp_icon"
