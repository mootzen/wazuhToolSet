#!/bin/bash

# Paths to Wazuh rules
RULES_DIR="/var/ossec/ruleset/rules"
LOCAL_RULES="/var/ossec/etc/rules/local_rules.xml"

# Function to check if rule ID exists and return the file
rule_exists() {
    local id="$1"
    local file

    # Search in main rules directory and local_rules.xml
    file=$(grep -rl "<rule id=\"$id\"" "$RULES_DIR" 2>/dev/null)
    if [[ -z "$file" && -f "$LOCAL_RULES" ]]; then
        if grep -q "<rule id=\"$id\"" "$LOCAL_RULES"; then
            file="$LOCAL_RULES"
        fi
    fi

    if [[ -n "$file" ]]; then
        echo "$file"
        return 0
    else
        return 1
    fi
}

# Check input arguments
if [[ -z "$1" ]]; then
    echo "Usage: $0 <rule_id> or $0 <start_id-end_id>"
    exit 1
fi

# Single rule ID check
if [[ "$1" =~ ^[0-9]+$ ]]; then
    file_path=$(rule_exists "$1")
    if [[ $? -eq 0 ]]; then
        echo "Rule ID $1 is already in use. Found in: $file_path"
    else
        echo "Rule ID $1 is free."
    fi
    exit 0
fi

# Range check
if [[ "$1" =~ ^([0-9]+)-([0-9]+)$ ]]; then
    start_id=${BASH_REMATCH[1]}
    end_id=${BASH_REMATCH[2]}

    if (( start_id > end_id )); then
        echo "Invalid range: Start ID is greater than End ID."
        exit 1
    fi

    echo "Checking rule IDs between $start_id and $end_id..."
    for (( id=start_id; id<=end_id; id++ )); do
        file_path=$(rule_exists "$id")
        if [[ $? -eq 0 ]]; then
            echo "Rule ID $id is in use. Found in: $file_path"
        else
            echo "Rule ID $id is free."
        fi
    done
    exit 0
fi

# Invalid input
echo "Invalid input format. Use a single rule ID or a range (e.g., 100000-100010)."
exit 1