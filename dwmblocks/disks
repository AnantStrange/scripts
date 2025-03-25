#!/bin/sh

case $BLOCK_BUTTON in
        6) "$TERMINAL" -e "$EDITOR" "$0" ;;
esac

a=$(df -h / | awk ' /[0-9]/ {print " :"$3 "/" $2}')
b=$(df -h /home | awk ' /[0-9]/ {print "󱂵 :"$3 "/" $2}')

printf "%s %s\n" "$a" "$b" 

