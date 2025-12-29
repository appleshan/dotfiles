#!/usr/bin/env bash
xmodmap ~/.config/metaesc/code01s1.xmodmap
sleep 0.2
killall xcape
sleep 0.2
xcape -e 'Alt_L=Escape;Control_L=Control_R|c;Shift_L=space;Super_L=Cancel;Super_R=Redo;' -t 240
notify-send "Keymap: code01s1.xmodmap (MetaEsc)" -t 3000
