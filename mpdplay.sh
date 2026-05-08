#!/usr/bin/env zsh

a=$(mpc listall | dmenu -f -l 10 -p "Music >");
[[ -n "$a" ]] && mpc insert "$a"; mpc seek;


