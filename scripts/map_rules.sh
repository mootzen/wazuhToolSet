#!/bin/bash

# Paths to rule files
RULES_DIR="/var/ossec/ruleset/rules"
LOCAL_RULES="/var/ossec/etc/rules/local_rules.xml"
OUTPUT_FILE="wazuh_rules_table.txt"

# Function to extract rule information
extract_rules() {
    local file="$1"
    awk '
        /<rule id=/ {
            match($0, /id="([0-9]+)"/, id);
            rule_id = id[1];
        }
        /<description>/ {
            match($0, /<description>([^<]+)<\/description>/, desc);
            rule_desc = desc[1];
            printf "%-10s | %-50s | %s\n", rule_id, rule_desc, "'"$file"'";
        }
    ' "$file"
}

# Print header
echo "Rule ID    | Description                                       | File" | tee "$OUTPUT_FILE"
echo "---------------------------------------------------------------------------------" | tee -a "$OUTPUT_FILE"

# Process all rule files and write to file
for rule_file in "$RULES_DIR"/*.xml "$LOCAL_RULES"; do
    if [[ -f "$rule_file" ]]; then
        extract_rules "$rule_file" | tee -a "$OUTPUT_FILE"
    fi
done

echo "Table written to $OUTPUT_FILE"