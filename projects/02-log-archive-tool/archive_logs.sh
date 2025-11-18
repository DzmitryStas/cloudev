#!/usr/bin/env bash
# Simple Log Archiving Script

# What it does:
# 1. Creates a timestamp
# 2. Creates a folder called "archive" if it doesn't exist
# 3. Compresses everything in the "logs" folder into a .tar.gz file
# 4. Moves the archive file into the "archive" folder

set -e  # exit immediately if a command fails

# 1. Create a timestamp
timestamp=$(date +"%Y-%m-%d-%H-%M-%S")

# 2. Create archive folder if missing
mkdir -p archive

# 3. Name of archive file
archive_name="logs-$timestamp.tar.gz"

# 4. Compress the logs folder
tar -czf "$archive_name" logs

# 5. Move the archive to archive/ folder
mv "$archive_name" archive/

echo "Archive created: archive/$archive_name"


