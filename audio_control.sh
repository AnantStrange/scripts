#! /bin/bash

# Define the default audio sink
SINK="@DEFAULT_AUDIO_SINK@"
SOURCE="@DEFAULT_AUDIO_SOURCE@"

# Get the current volume
get_speaker_volume() {
    wpctl get-volume "$SINK"  | awk '{print $2}' | sed 's/\[MUTED\]//; s/[^0-9.]//g' | awk '{printf "%.0f%%\n", $1 * 100}'
}

get_mic_volume() {
    wpctl get-volume "$SOURCE" | awk '{print $2}' | sed 's/\[MUTED\]//; s/[^0-9.]//g' | awk '{printf "%.0f%%\n", $1 * 100}'
}

get_speaker_mute_status() {
    wpctl get-volume "$SINK" | grep -q '\[MUTED\]' && echo "Muted" || echo "Unmuted"
}

get_mic_mute_status() {
    wpctl get-volume "$SOURCE" | grep -q '\[MUTED\]' && echo "Muted" || echo "Unmuted"
}


# Adjust volume or toggle mute
case "$1" in
    speaker-increase)
        wpctl set-volume $SINK "$2"%+ & pkill -RTMIN+21 dwmblocks
        volume=$(get_speaker_volume)
        notify-send -t 5000 -h int:value:"$volume" -h string:synchronous:progress "Volume" "$volume"
        ;;
    speaker-decrease)
        wpctl set-volume $SINK "$2"%- & pkill -RTMIN+21 dwmblocks
        volume=$(get_speaker_volume)
        notify-send -t 5000 -h int:value:"$volume" -h string:synchronous:progress "Volume" "$volume"
        ;;
    speaker-toggle-mute)
        volume=$(get_speaker_volume)
        if [[ $(get_speaker_mute_status) == "Muted" ]]; then
            notify-send -t 5000 -h int:value:"$volume" -h string:synchronous:progress "Volume" "Unmuted $volume"
        else
            notify-send -t 5000 -h int:value:"$volume" -h string:synchronous:progress "Volume" "Muted $volume"
        fi
        wpctl set-mute "$SINK" toggle
        pkill -RTMIN+21 dwmblocks
        ;;
    mic-increase)
        wpctl set-volume "$SOURCE" "$2"%+ & pkill -RTMIN+21 dwmblocks
        volume=$(get_mic_volume)
        notify-send -t 5000 -h int:value:"$volume" -h string:synchronous:progress "Mic Volume" "$volume"
        ;;
    mic-decrease)
        wpctl set-volume "$SOURCE" "$2"%- & pkill -RTMIN+21 dwmblocks
        volume=$(get_mic_volume)
        notify-send -t 5000 -h int:value:"$volume" -h string:synchronous:progress "Mic Volume" "$volume"
        ;;
    mic-toggle-mute)
        volume=$(get_mic_volume)
        if [[ $(get_mic_mute_status) == "Muted" ]]; then
            notify-send -t 5000 -h int:value:"$volume" -h string:synchronous:progress "Mic Volume" "Unmuted $volume"
        else
            notify-send -t 5000 -h int:value:"$volume" -h string:synchronous:progress "Mic Volume" "Muted $volume"
        fi
        wpctl set-mute "$SOURCE" toggle
        pkill -RTMIN+21 dwmblocks
        ;;
    *)
        echo "Usage: basename $0 {speaker-increase|speaker-decrease|speaker-toggle-mute|mic-increase|mic-decrease|mic-toggle-mute} [amount]"
        exit 1
        ;;
esac

