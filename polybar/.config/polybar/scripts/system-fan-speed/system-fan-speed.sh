#!/bin/sh
# @See https://wiki.archlinux.org/index.php/Fan_speed_control

speed=$(sensors | grep fan2 | cut -d " " -f 19)

if [ "$speed" != "" ]; then
    speed_round=$(echo "scale=1;$speed" | bc -l )
    echo "$speed_round RPM"
else
    echo "0 RPM"
fi
