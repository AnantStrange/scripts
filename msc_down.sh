#!/bin/sh

show_help() {
    echo "Usage: $0 <input_file> [audio_quality]"
    echo "Download YouTube videos using yt-dlp."
    echo "  <input_file>: File containing YouTube video URLs, one per line."
    echo "  [audio_quality]: Optional audio quality specifier for yt-dlp."
}

# Check if the help flag is provided
if [ "$#" -eq 1 ] && [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

# Check if yt-dlp is installed
if ! command -v yt-dlp &> /dev/null; then
    echo "yt-dlp is not installed. Please install it first."
    exit 1
fi

input_file="$1"
audio_quality="$2"

# Read lines from the input file
while IFS= read -r url; do
    # Remove leading and trailing whitespaces
    url=$(echo "$url" | awk '{$1=$1};1')

    # Check if the line is not empty
    if [ -n "$url" ]; then
        echo "Downloading video from: $url"

        # Construct yt-dlp command based on the presence of audio_quality argument
        if [ -n "$audio_quality" ]; then
            yt-dlp -o "$HOME/msc/%(title)s.%(ext)s" -x --audio-multistreams --audio-format mp3 --audio-quality "$audio_quality" -N 5 -f bestaudio --add-metadata --embed-thumbnail  "$url"
        else
            yt-dlp -o "$HOME/msc/%(title)s.%(ext)s" -x --audio-multistreams --audio-format mp3 -N 5 -f bestaudio --add-metadata --embed-thumbnail  "$url"
        fi

        echo "Download complete."
        echo
    fi
done < "$input_file"

echo "All videos downloaded successfully."




