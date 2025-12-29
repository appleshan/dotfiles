#!/usr/bin/env bash
xmodmap ~/.config/metaesc/code01.xmodmap
killall xcape
notify-send "Keymap: default" -t 3000
