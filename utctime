#! /usr/bin/env bash

show_help() {
    printf "Usage: utctime [-r|--reverse] <TIME_HH:MM>\n"
    printf "Convert UTC to local time (default) or local time to UTC with -r/--reverse.\n"
    exit 0
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
fi

if [ -z "$2" ] && [ "$1" != "-r" ] && [ "$1" != "--reverse" ]; then
    # If no options are passed, assume first argument is UTC time
    input_time="$1"
    conversion="UTC to Local"
    converted_time=$(date -d "$input_time UTC" +"%H:%M %Z")
elif [ "$1" = "-r" ] || [ "$1" = "--reverse" ]; then
    # Convert local time to UTC
    input_time="$2"
    conversion="Local to UTC"
    # Explicitly set the input time as local time
    converted_time=$(date -d "TZ=\"$(date +%Z)\" $input_time" -u +"%H:%M UTC")
else
    show_help
fi

echo "$conversion:"
echo "Input Time: $input_time"
echo "Converted Time: $converted_time"
