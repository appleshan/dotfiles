#!/usr/bin/env bash
xmodmap ~/projects/private/metaesc/lib/code01.xmodmap 
killall xcape
notify-send "Keymap: default" -t 3000
