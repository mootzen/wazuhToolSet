#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <keyword> <directory1> <directory2>"
    exit 1
fi

KEYWORD=$1
DIR1=$2
DIR2=$3

rename_files() {
    local DIR=$1
    if [ -d "$DIR" ]; then
        for file in "$DIR"/*.xml; do
            if [[ -f "$file" && "$file" == *"$KEYWORD"* ]]; then
                mv "$file" "${file%.xml}.xml.bak"
                echo "Renamed: $file -> ${file%.xml}.xml.bak"
            fi
        done
    else
        echo "Directory not found: $DIR"
    fi
}
#/var/ossec/etc/rules/ & /var/ossec/etc/rules/
rename_files "$DIR1"
rename_files "$DIR2"

echo "Renaming process completed."