#!/bin/sh

speed=$(sensors | grep fan2 | cut -d " " -f 19)

if [ "$speed" != "" ]; then
    speed_round=$(echo "scale=1;$speed/1000" | bc -l )
    echo "$speed_round kRPM"
else
   echo "#"
fi
