#!/bin/bash

# Path to Wazuh rules directory
RULES_DIR="/var/ossec/ruleset/rules"

# Function to check if rule ID exists
rule_exists() {
    grep -r "<rule id=\"$1\"" $RULES_DIR >/dev/null 2>&1
    return $?
}

# Check input arguments
if [[ -z "$1" ]]; then
    echo "Usage: $0 <rule_id> or $0 <start_id-end_id>"
    exit 1
fi

# Single rule ID check
if [[ "$1" =~ ^[0-9]+$ ]]; then
    if rule_exists "$1"; then
        echo "Rule ID $1 is already in use."
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

    echo "Checking free rule IDs between $start_id and $end_id..."
    for (( id=start_id; id<=end_id; id++ )); do
        if ! rule_exists "$id"; then
            echo "Rule ID $id is free."
        fi
    done
    exit 0
fi

# Invalid input
echo "Invalid input format. Use a single rule ID or a range (e.g., 100000-100010)."
exit 1