#!/bin/bash
# rofi_power menu

action=$(echo -e "lock\nlogout\nshutdown\nreboot" | rofi -dmenu -p "power:")

if [[ "$action" == "lock" ]]
then
    ~/.config/i3lock-fancy-multimonitor/lock
fi

if [[ "$action" == "logout" ]]
then
    i3-msg exit
fi

if [[ "$action" == "shutdown" ]]
then
    shutdown now
fi

if [[ "$action" == "reboot" ]]
then
    reboot
fi
