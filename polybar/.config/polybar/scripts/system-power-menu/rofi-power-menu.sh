#!/bin/bash

rofi \
-show p \
-modi p:$HOME/.config/rofi/scripts/rofi-power-menu/rofi-power-menu \
-font 'Noto Sans Mono 22' \
-theme Arc-Dark \
-theme-str 'window {width: 8em;} listview {lines: 6;}'
