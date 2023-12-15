#!/bin/bash

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                  _            _
#   ___ ___  _ __ ___  _ __  _   _| |_ ___ _ __(_) ___ _ __ _ __ ___  ___
#  / __/ _ \| '_ ` _ \| '_ \| | | | __/ _ \ '__| |/ _ \ '__| '_ ` _ \/ __|
# | (_| (_) | | | | | | |_) | |_| | ||  __/ |  | |  __/ |  | | | | | \__ \
#  \___\___/|_| |_| |_| .__/ \__,_|\__\___|_| _/ |\___|_|  |_| |_| |_|___/
#                     |_|                    |__/
#
# https://www.computerjerms.com
# https://github.com/computerjerms
#
#            Script to change wallpapers on multihead systems
#         Useful for Window Managers with no Desktop Environment

# Please read the README.md for documentation
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                         CONFIG
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Moniotor 1 Wallpaper Directory
MON1WALLPAPERS=~/persist/pictures/wallpaper/bing-wallpaper
# Change monitor 1 wallpaper in "x" seconds
MON1TIME=45

# Monitor 2 Wallpaper Directory
MON2WALLPAPERS=~/persist/pictures/wallpaper/bing-wallpaper
# Change monitor 2 wallpaper in "x" seconds
MON2TIME=45

# Monitor 3 Wallpaper Directory
MON3WALLPAPERS=~/persist/pictures/wallpaper/bing-wallpaper
# Change monitor 3 Wallpaper in "x" seconds
MON3TIME=45

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                         SCRIPT
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MON1RANGE=$(ls $MON1WALLPAPERS | wc -l)
MON2RANGE=$(ls $MON2WALLPAPERS | wc -l)
MON3RANGE=$(ls $MON3WALLPAPERS | wc -l)

function main_monitor () {
    for i in 2 ; do
        let "number = $RANDOM % $MON1RANGE"
        IMAGE=$(ls $MON1WALLPAPERS | head -$number | tail -1 )
        sed -i $i' c\file='"$MON1WALLPAPERS/$IMAGE"'' ~/.config/nitrogen/bg-saved.cfg
    done
}

function left_monitor () {
    for i in 7; do
        let "number = $RANDOM % $MON3RANGE"
        IMAGE=$(ls $MON3WALLPAPERS | head -$number | tail -1 )
        sed -i $i' c\file='"$MON3WALLPAPERS/$IMAGE"'' ~/.config/nitrogen/bg-saved.cfg
    done
}

function right_monitor () {
    for i in 12; do
        let "number = $RANDOM % $MON2RANGE"
        IMAGEVERT=$(ls $MON2WALLPAPERS | head -$number | tail -1 )
        sed -i $i' c\file='"$MON2WALLPAPERS/$IMAGEVERT"'' ~/.config/nitrogen/bg-saved.cfg
    done
}

function set_main_monitor () {
    main_monitor
    nitrogen --restore
    sleep $MON1TIME
}

function set_left_monitor () {
    left_monitor
    nitrogen --restore
    sleep $MON3TIME
}

function set_right_monitor () {
    right_monitor
    nitrogen --restore
    sleep $MON2TIME
}

function set_wallpapers () {
    set_main_monitor 
    set_left_monitor
    set_right_monitor
}


while true
do
    set_wallpapers
done
