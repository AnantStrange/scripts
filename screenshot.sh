#!/usr/bin/env bash

SAVE_DIR="$HOME/Pictures"
TIMESTAMP=$(date "+%d_%b_%H:%M:%S")
DEFAULT_NAME="Screenshot_$TIMESTAMP.png"

show_usage() {
    echo "Usage: $0 [-s] [-f] [-n]"
    echo "  -s   Take a screenshot of a selected area."
    echo "  -f   Capture the entire screen."
    echo "  -n   Prompt for a custom name using dmenu."
    exit 1
}

# Flags
selection=false
fullscreen=false
named=false

while getopts "sfn" opt; do
    case "$opt" in
        s) selection=true ;;
        f) fullscreen=true ;;
        n) named=true ;;
        *) show_usage ;;
    esac
done

# Determine filename
if $named; then
    NAME=$(echo "" | dmenu -p "Enter screenshot name:")
    [[ -z "$NAME" ]] && exit 1
    FILE="$SAVE_DIR/${NAME}.png"
else
    FILE="$SAVE_DIR/$DEFAULT_NAME"
fi

# Capture
if $selection; then
    maim -f png -u -m 10 -s | tee "$FILE" | xclip -selection clipboard -t image/png
elif $fullscreen; then
    maim -f png -u -m 10 | tee "$FILE" | xclip -selection clipboard -t image/png
else
    show_usage
fi

