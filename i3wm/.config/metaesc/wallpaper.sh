#!/usr/bin/env bash

wallpapers=(~/persist/pictures/bing-wallpaper/*)
count=$(command ls -1q  ~/persist/pictures/bing-wallpaper/ | wc -l)
ps aux | grep wallpaper.sh | grep -v "grep\|vim\|$$" | awk '{ print $2 }' | xargs kill -9
i=$(($RANDOM % $count))
notify-send "Wallpaper Reset" -t 3000
while true
do
	feh --bg-scale ${wallpapers[$i]} --bg-fill
	i=$(( (i + 1) % $count))
    sleep 600
done
