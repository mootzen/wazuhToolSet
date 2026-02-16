#!/bin/bash
set -euo pipefail

RULES_DIR="/var/ossec/ruleset/rules"
ETC_RULES_DIR="/var/ossec/etc/rules"
LOCAL_RULES="/var/ossec/etc/rules/local_rules.xml"

# Build an index of all XML files we should scan (follows symlinks).
# -L: follow symlinks
# -type f: only files
# -iname '*.xml': any case
mapfile -t XML_FILES < <(
  {
    find -L "$RULES_DIR" -type f -iname '*.xml' -print 2>/dev/null
    find -L "$ETC_RULES_DIR" -type f -iname '*.xml' -print 2>/dev/null
  } | sort -u
)

# Ensure local_rules.xml is included (even if find missed it for any reason)
if [[ -f "$LOCAL_RULES" ]]; then
  XML_FILES+=("$LOCAL_RULES")
fi

usage() {
  echo "Usage: $0 <rule_id> or $0 <start_id-end_id>"
}

# Function to check if rule ID exists and return the first file that contains it
rule_exists() {
  local id="$1"
  local f

  # Match:
  #   <rule id="123"
  #   <rule    id = "123"
  #   <rule id='123'
  # and allow other attrs before/after id=...
  local re='<rule[^>]*[[:space:]]id[[:space:]]*=[[:space:]]*["'\'']'"$id"'["'\'']'

  for f in "${XML_FILES[@]}"; do
    [[ -r "$f" ]] || continue
    if grep -qE "$re" "$f"; then
      echo "$f"
      return 0
    fi
  done

  return 1
}

if [[ $# -lt 1 || -z "${1:-}" ]]; then
  usage
  exit 1
fi

# Single rule ID check
if [[ "$1" =~ ^[0-9]+$ ]]; then
  if file_path=$(rule_exists "$1"); then
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
    if file_path=$(rule_exists "$id"); then
      echo "Rule ID $id is in use. Found in: $file_path"
    else
      echo "Rule ID $id is free."
    fi
  done
  exit 0
fi

echo "Invalid input format. Use a single rule ID or a range (e.g., 100000-100010)."
exit 1
