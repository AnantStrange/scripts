#!/bin/sh
# Prints all batteries, their percentage remaining and an emoji corresponding
# to charge status (🔌 for plugged up, 🔋 for discharging on battery, etc.).
lock_path="/tmp/battery_script.lock"

case $BLOCK_BUTTON in
    3) notify-send "🔋 Battery module" "🔋: discharging
        🛑: not charging
        ♻: stagnant charge
        🔌: charging
        ⚡: charged
        ❗: battery very low!
        - Scroll to change adjust xbacklight." ;;
    4) light -A 5 ;;
    5) light -U 5 ;;
    6) "$TERMINAL" -e "$EDITOR" "$0" ;;
esac

# Loop through all attached batteries and format the info
for battery in /sys/class/power_supply/BAT?*; do
    # If non-first battery, print a space separator.
    [ -n "${capacity+x}" ] && printf " "
    # Sets up the status and capacity
    case "$(cat "$battery/status" 2>&1)" in
        "Full") status="⚡" ;;
        "Discharging") status="🔋" ;;
        "Charging") status="🔌" ;;
        "Not charging") status="🛑" ;;
        "Unknown") status="♻️" ;;
        *) exit 1 ;;
    esac
    capacity="$(cat "$battery/capacity" 2>&1)"
    # Will make a warn variable if discharging and low
    [ "$status" = "🔋" ] && [ "$capacity" -le 25 ] && warn="❗"
    # Prints the info
    printf "%s%s%d%%" "$status" "$warn" "$capacity"; unset warn
done && printf "\\n"

[ -e "$lock_path" ] && exit 0;
touch "$lock_path"
status="$(cat /sys/class/power_supply/BAT0/status)"

if [[ "$status" = "Discharging" || "$status" = "Not charging" || "$status" = "Unknown" ]];
then
    if [ "$capacity" -lt 16 ];
    then

        if [ -f /tmp/hibernate ]; then
            source /tmp/hibernate
        else
            hibernate_enabled=true
        fi

        notify-send -u critical -t 5000 "Warning Battery low" "Plug in charger !!"

        if [ "$hibernate_enabled" != true ]; then
            exit 0;
        fi

        for number in $(seq 60); do
            status=$(cat /sys/class/power_supply/BAT0/status)
            if [ "$status" = "Charging" ]; then
                dunstctl close
                exit 0
            fi
            progress=$(( number * 100 / 60 ))
            notify-send -u critical -t 60000 -h string:int:value:$progress -h string:synchronous:progress "Battery Low" "hibernate_enabled: $hibernate_enabled\nHybrid-Sleeping in $((60 - number)) seconds"
            sleep 1
        done
        dunstctl close


        # i3lock-fancy && systemctl hybrid-sleep;
        if [ "$status" = "Discharging" ] && [ "$hibernate_enabled" = true ]; then
            if command -v i3lock-fancy >/dev/null 2>&1; then
                i3lock-fancy & systemctl hybrid-sleep
            elif command -v i3lock >/dev/null 2>&1; then
                i3lock & systemctl hybrid-sleep
            else
                notify-send -u critical "Error: Lock utility not found" "Please install either 'i3lock-fancy' or 'i3lock' for hybrid sleep to work."
                printf "Error: Lock utility not found\nPlease install either 'i3lock-fancy' or 'i3lock' for hybrid sleep to work.\n"
                exit 1
            fi
        fi

    elif [ "$capacity" -lt 26 ];
    then
        notify-send -u critical -t 5000 "Warning Battery low" "Plug in charger !!"

    fi 

elif { [ "$status" = "Charging" ] || [ "$status" = "Full" ]; } && [ "$capacity" -gt 97 ];
then
    notify-send "Charging full" "Remove charger."
fi 

[ -e "$lock_path" ] && rm "$lock_path"
