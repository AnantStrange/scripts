#!/usr/bin/env bash

SAVE_DIR="$HOME/Pictures"
TIMESTAMP=$(date "+%d_%b_%H:%M:%S")
DEFAULT_NAME="Screenshot_$TIMESTAMP.png"

show_usage() {
    echo "Usage: $0 [-s] [-f] [-n]"
    echo "  -s   Take a screenshot of a selected area."
    echo "  -f   Capture the entire screen."
    echo "  -n   Capture the entire screen with a custom name (prompted via dmenu)."
    exit 1
}

while getopts "sfn" opt; do
    case "$opt" in
        s)  # Selection mode
            FILE="$SAVE_DIR/$DEFAULT_NAME"
            maim -f png -m 10 -s | tee "$FILE" | xclip -selection clipboard -t image/png
            ;;
        f)  # Fullscreen mode
            FILE="$SAVE_DIR/$DEFAULT_NAME"
            maim -f png -m 10 | tee "$FILE" | xclip -selection clipboard -t image/png
            ;;
        n)  # Named screenshot using dmenu
            NAME=$(echo "" | dmenu -p "Enter screenshot name:")
            [[ -z "$NAME" ]] && exit 1  # Exit if no name is provided
            FILE="$SAVE_DIR/${NAME}.png"
            maim -f png -m 10 | tee "$FILE" | xclip -selection clipboard -t image/png
            ;;
        *)  # Invalid flag
            show_usage
            ;;
    esac
done

