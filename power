#!/bin/sh

var=$(echo -e "Power-off\nReboot\nSuspend\nHibernate\nHybrid-sleep\nkill-dwm" | dmenu)

if [ "$var" == "Power-off" ]; then
    sudo -A shutdown now
elif [ "$var" == "Reboot" ]; then
    sudo -A reboot
elif [ "$var" == "kill-dwm" ]; then
    killall dwmblocks & killall dunst & killall dwm
elif [ "$var" == "Suspend" ]; then
    pkexec systemctl suspend && i3lock
elif [ "$var" == "Hibernate" ]; then
    pkexec systemctl hibernate && i3lock-fancy
elif [ "$var" == "Hybrid-sleep" ]; then
    pkexec systemctl hybrid-sleep && i3lock-fancy
fi

