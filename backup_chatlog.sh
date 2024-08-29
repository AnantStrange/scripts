#! /usr/bin/env sh

# Define the source and backup directories
SOURCE="$HOME/programming2/scrap/chat.log"
BACKUP_DIR="$HOME/programming2/scrap/backups/"

# Create a timestamp
TIMESTAMP=$(date +"%d%m%Y_%H%M%S")

# Create a backup copy
cp "$SOURCE" "$BACKUP_DIR/chatlog_$TIMESTAMP.txt"

