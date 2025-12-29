#!/bin/sh
if [ $(hostname) == "cyberhacklab" ]; then
    xrandr --auto --output HDMI-1 --primary --mode 1920x1080 --rate 60.00
fi
