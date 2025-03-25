#!/bin/sh

#if [ -d "/sys/class/net/enp0s20f0u1/" ];

a=$(find /sys/class/net/enp0s2* 2>/dev/null)
if [ -n "$a" ]
then
        a=$(echo $a | cut -d"/" -f 5);
fi

tmp=$(cat /sys/class/net/wlp3s0/operstate)
if [ $tmp == 'up' ];
then
        #b=$(iwgetid -r | cut -c1-8)
        b=$(iwgetid -r)
fi

#echo "a :"$a
#echo "b :"$b

if [ -n "$a" ];
then
        if [ -n "$b" ];
        then
                echo -e ":$a,$b"
        else
                echo -e ":$a"
        fi
else
        echo -e ":$b"
fi
