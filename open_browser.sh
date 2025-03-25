#! /usr/bin/env bash

for browser in $BROWSERS; do  # Automatically splits on spaces
    if command -v "$browser" >/dev/null 2>&1; then
        exec "$browser" "$@"  # Launch first available browser
    fi
done

notify-send -u normal -a "$0" -i "browser" "No Browser Found" "Could not find a valid browser in the list.\n$BROWSERS"


