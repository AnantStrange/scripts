#! /usr/bin/env sh

# Define the source and backup directories
SOURCE="$HOME/programming2/LeChat_Scrap/chat.log"
BACKUP_DIR="$HOME/programming2/LeChat_Scrap/backups/"

# Create a timestamp
TIMESTAMP=$(date +"%d%m%Y_%H%M%S")

# Create a backup copy
cp "$SOURCE" "$BACKUP_DIR/chatlog_$TIMESTAMP.txt"

