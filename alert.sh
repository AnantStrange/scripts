#!/bin/sh

[ "$2" == "Battery Low" ] && exit 0
[ "$2" == "Volume" ] && exit 0
[ "$2" == "Brightness" ] && exit 0

mpv --volume=65 ~/scripts/hey_listen.ogg > /dev/null

