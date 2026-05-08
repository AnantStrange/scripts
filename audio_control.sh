#!/bin/bash

# Define the default audio sink/source using pactl syntax
SINK="@DEFAULT_SINK@"
SOURCE="@DEFAULT_SOURCE@"
LOCKFILE="/tmp/audio-control.lock"
REFR_SIG="21"

# Notification IDs for replacement (fixed numbers for each type)
SPEAKER_NID=1001
MIC_NID=1002
MUTE_NID=1003

# Try to acquire lock, exit if another instance is running
exec 9>"$LOCKFILE"
if ! flock -n 9; then
    # Another instance is running, exit silently
    exit 0
fi

# Get the current volume using pactl
get_speaker_volume() {
    pactl get-sink-volume "$SINK" | grep -oP '\d+%' | head -1 | tr -d '%'
}

get_mic_volume() {
    pactl get-source-volume "$SOURCE" | grep -oP '\d+%' | head -1 | tr -d '%'
}

get_speaker_mute_status() {
    pactl get-sink-mute "$SINK" | grep -q "yes" && echo "Muted" || echo "Unmuted"
}

get_mic_mute_status() {
    pactl get-source-mute "$SOURCE" | grep -q "yes" && echo "Muted" || echo "Unmuted"
}

# Adjust volume or toggle mute
case "$1" in
    speaker-increase)
        pactl set-sink-volume "$SINK" "+$2%"
        volume=$(get_speaker_volume)
        dunstify -r $SPEAKER_NID -t 2000 -h int:value:"$volume" "Volume" "$volume%"
        ;;
    speaker-decrease)
        pactl set-sink-volume "$SINK" "-$2%"
        volume=$(get_speaker_volume)
        dunstify -r $SPEAKER_NID -t 2000 -h int:value:"$volume" "Volume" "$volume%"
        ;;
    speaker-toggle-mute)
        pactl set-sink-mute "$SINK" toggle
        volume=$(get_speaker_volume)
        status=$(get_speaker_mute_status)
        dunstify -r $MUTE_NID -t 2000 -h int:value:"$volume" "Volume" "$status $volume%"
        ;;
    mic-increase)
        pactl set-source-volume "$SOURCE" "+$2%"
        volume=$(get_mic_volume)
        dunstify -r $MIC_NID -t 2000 -h int:value:"$volume" "Mic Volume" "$volume%"
        ;;
    mic-decrease)
        pactl set-source-volume "$SOURCE" "-$2%"
        volume=$(get_mic_volume)
        dunstify -r $MIC_NID -t 2000 -h int:value:"$volume" "Mic Volume" "$volume%"
        ;;
    mic-toggle-mute)
        pactl set-source-mute "$SOURCE" toggle
        volume=$(get_mic_volume)
        status=$(get_mic_mute_status)
        dunstify -r $MUTE_NID -t 2000 -h int:value:"$volume" "Mic Volume" "$status $volume%"
        ;;
    *)
        echo "Usage: $0 {speaker-increase|speaker-decrease|speaker-toggle-mute|mic-increase|mic-decrease|mic-toggle-mute} [amount]"
        exit 1
        ;;
esac

# Refresh dwmblocks (uncomment if you want this)
pkill -RTMIN+$REFR_SIG dwmblocks &
