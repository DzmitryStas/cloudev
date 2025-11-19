#!/usr/bin/env bash

# =============================
#  Simple Home Backup Script
# =============================
# This script:
# 1. Makes a timestamp
# 2. Creates a "backup" folder
# 3. Compresses /home/vagrant
# 4. Skips folders you don't want (like .cache)
# 5. Shows progress
# 6. Deletes old backups (older than 14 days)
# =============================

# Stop script if a command fails
set -e

# ----- SETTINGS YOU CAN CHANGE -----

HOME_DIR="/home/vagrant"   # folder you want to back up
BACKUP_DIR="backup"        # where backups are stored
KEEP_DAYS=14               # delete backups older than X days

# Excluded folders (you can add more)
EXCLUDE_1="$HOME_DIR/.cache"
EXCLUDE_2="$HOME_DIR/.local/share/Trash"

# -----------------------------------

# 1. Create timestamp
timestamp=$(date +"%Y-%m-%d-%H-%M-%S")

# Name of backup file
ARCHIVE_NAME="home-backup-$timestamp.tar.gz"

# 2. Make backup folder if missing
mkdir -p "$BACKUP_DIR"

# 3. Create the backup
echo "Creating backup... this may take a few minutes."
tar -czvf "$ARCHIVE_NAME" \
    --exclude="$EXCLUDE_1" \
    --exclude="$EXCLUDE_2" \
    "$HOME_DIR"

# 4. Move backup file into backup/ folder
mv "$ARCHIVE_NAME" "$BACKUP_DIR/"
echo "Backup created: $BACKUP_DIR/$ARCHIVE_NAME"

# 5. Remove backups older than KEEP_DAYS
echo "Deleting backups older than $KEEP_DAYS days..."
find "$BACKUP_DIR" -type f -name "home-backup-*.tar.gz" -mtime +$KEEP_DAYS -delete

echo "Backup finished!"

