#!/usr/bin/env bash
xmodmap ~/.config/metaesc/code01s2.xmodmap
sleep 0.2
killall xcape
sleep 0.2
xcape -e 'Alt_L=Escape;Control_L=Control_R|c;Shift_R=space;Shift_L=Cancel;Super_R=Redo;' -t 240

notify-send "Keymap: code01s2" -t 3000
