#!/bin/bash

# options to be displayed
option0=" lock"
option1=" logout"
option2=" suspend"
option3=" reboot"
option4=" shutdown"

# options passed into variable
options="$option0\n$option1\n$option2\n$option3\n$option4"

#chosen="$(echo -e "$options" | rofi -lines 8 -width -22 -dmenu -p "power")"
chosen="$(echo -e "$options" | rofi -lines 8 -columns 12 -dmenu -p "power")"
case $chosen in
    $option0)
        # i3lock-fancy;;
        $HOME/.config/i3lock-fancy-multimonitor/lock;;
    $option1)
        # i3-msg exit;;
        i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit';;
    $option2)
        systemctl suspend;;
    $option3)
        systemctl reboot;;
	$option4)
        systemctl poweroff;;
esac

