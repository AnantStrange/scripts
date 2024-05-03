#!/bin/sh

# Prints the current volume or 🔇 if muted.

case $BLOCK_BUTTON in
	1) setsid -f "$TERMINAL" -e pulsemixer ;;
	2) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;   # middle click
	4) wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ ;; #scroll up
	5) wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%- ;; #scroll down
	3) notify-send "📢 Volume module" "\- Shows volume 🔊, 🔇 if muted.
- Middle click to mute.
- Scroll to change."   ;; #right click

	6) "$TERMINAL" -e "$EDITOR" "$0" ;;
esac

if ! command -v wpctl &> /dev/null; then
    echo -e "\e[1;31mwpctl is not installed."
    echo -e "\e[1;31mCheck is wireplumber is installed correctly"

    notify-send -u critical -a "volume/script" -t 4000 "Error: wpctl is not installed" "Please check if WirePlumber is installed correctly."

    exit 1
fi

if ! command -v bc &> /dev/null; then
    echo -e "\e[1;31mbc is not installed.\e[0m To install on:"
    echo -e "  - \e[1;34mDebian/Ubuntu (apt):\e[0m sudo apt install bc"
    echo -e "  - \e[1;34mArch Linux (pacman):\e[0m sudo pacman -S bc"
    echo -e "  - \e[1;34mGentoo (emerge):\e[0m sudo emerge -av sys-apps/bc"

    notify-send -u critical -a "volume/script" -t 4000 "Error: bc is not installed" "Please check if WirePlumber is installed correctly."

    exit 1
fi

volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -oP 'Volume: \K.*')
if [ "$volume" = "0.00" ]; then
    echo "🔇";
    exit;
fi


vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -oP 'Volume: \K[0-9.]+')
vol=$(printf "%.0f" $(echo "$vol * 100" | bc))

if [ "$vol" -gt "70" ]; then
	icon="🔊"
elif [ "$vol" -gt "30" ]; then
	icon="🔉"
elif [ "$vol" -gt "0" ]; then
	icon="🔈"
else
        echo 🔇 && exit
fi

echo "$icon$vol%"
