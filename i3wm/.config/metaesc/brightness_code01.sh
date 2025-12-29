#!/usr/bin/env bash
# Description: Adjusts the screen brightness on systems with AMD GPUs by modifying system files.
# It takes a single argument specifying the amount to change the brightness (positive or negative).
# If no argument is provided, the default change is set to 0.
#
# Usage: ./set_brightness.sh <change_in_brightness>
var1=$1
[ -z "$var1" ] && var1="0"

brightness_file=/sys/class/backlight/amdgpu_bl1/brightness
mod=$(stat -c "%a" $brightness_file)
if [ $mod -ne 646 ]; then
    PASSWD="$(zenity --password --title=Authentication)"
    echo -e $PASSWD | sudo -S chmod 646 $brightness_file
fi
var1=$(($var1 + $(cat $brightness_file)))
[ $var -gt 255 ] && var1=255 #max brightness is 255
echo $var1 > $brightness_file
notify-send -t 500 "🌟 $var1"
# # 亮度配置:2 ends here
