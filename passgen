#!/bin/sh

a=$(dmenu -p "pass generate -nc") 
b=$(echo "$a" | awk '{print $2}')

if [ -z "$b" ]
then
    pass generate -nc "$a" 
else
    pass generate -nc "$a" "$b"
fi 

