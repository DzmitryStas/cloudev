#!/usr/bin/env bash

# Exit the script if something goes wrong
set -e

###########################################
# 1. Get a timestamp for the log filename
###########################################
# Example output: 20251115-120001
timestamp=$(date +"%Y%m%d-%H%M%S")

###########################################
# 2. Print date and hostname
###########################################
# $(date) shows current date and time
# $(hostname) shows the current machine's name
echo "===== Snapshot taken on $(date) ====="
echo "Hostname: $(hostname)"
echo

###########################################
# 3. Show disk usage for all filesystems
###########################################
# df -h = disk free, human readable sizes (GB, MB)
echo "===== Disk Usage (df -h) ====="
df -h
echo

###########################################
# 4. Show top 5 CPU-using processes
###########################################
# ps aux shows all processes
# --sort=-%cpu sorts from highest CPU usage
# head -n 6 shows the header + the top 5 processes
echo "===== Top 5 Processes by CPU ====="
ps aux --sort=-%cpu | head -n 6
echo

###########################################
# 5. Save all output to a log file
###########################################
# Instead of writing inside the file manually, we let the user
# redirect the script's output when they run it.
#
# Example: ./snapshot.sh > snapshot-20251115-120001.log
#
# But we ALSO want to print the filename for the user:
echo "Snapshot complete."
echo "Suggested log filename: snapshot-$timestamp.log"

