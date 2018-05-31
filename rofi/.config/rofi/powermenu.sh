#!/bin/bash
# rofi_power menu

action=$(rofi -dmenu -i -lines 5 -width -9 -hide-scrollbar < ~/.config/rofi/rofi-exit)

if [[ "$action" == "lock" ]]
then
    # $HOME/.config/i3lock-fancy-multimonitor/lock
    i3lock-fancy
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
