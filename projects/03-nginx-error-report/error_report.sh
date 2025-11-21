#!/usr/bin/env bash
#
# Error Log Focus
#
# Usage:
#   ./analyze_logs.sh access.log
#
# What the script does:
# - Accepts a log file as first argument
# - Checks that the file exists
# - Counts total error lines (4xx, 5xx)
# - Shows top 5 IPs that generated errors
# - Saves all error lines into errors.log
# - Shows status code breakdown

set -euo pipefail

# 1) Check if user passed a file name
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <logfile>"
  exit 1
fi

logfile="$1"

# 2) Check if file exists
if [[ ! -f "$logfile" ]]; then
  echo "Error: file '$logfile' does not exist"
  exit 1
fi

echo "Log file: $logfile"
echo

# 3) Count total error lines (status code starts with 4 or 5)
total_errors=$(awk '$9 ~ /^[45]/' "$logfile" | wc -l)
echo "Total errors (4xx/5xx): $total_errors"
echo

# 4) Count unique IPs (all requests)
unique_ips=$(cut -d' ' -f1 "$logfile" | sort -u | wc -l)
echo "Unique IPs in log:     $unique_ips"
echo

# 5) Top 5 IPs causing the most errors
echo "Top 5 error-generating IPs:"
awk '$9 ~ /^[45]/ {print $1}' "$logfile" | sort | uniq -c | sort -nr | head -n 5
echo

# 6) Save all error lines to errors.log
echo "Saving error lines to errors.log ..."
awk '$9 ~ /^[45]/' "$logfile" > errors.log
echo "Saved."
echo

# 7) Status code counts
echo "Status code counts:"
awk '$9 ~ /^[0-9]+$/ {print $9}' "$logfile" | sort | uniq -c | sort -nr | awk '{printf "%s: %s\n", $2, $1}'

