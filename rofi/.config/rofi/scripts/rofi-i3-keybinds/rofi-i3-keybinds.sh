#!/bin/bash

script_name=$0
script_full_path=$(dirname "$0")

OPTIONS=$(python3 "$script_full_path/parser.py" ~/.config/i3/config)
LAUNCHER="rofi -dmenu -i -p "

SELECTED=$(echo "${OPTIONS/, \n}" | $LAUNCHER)
echo "$SELECTED" | python3 "$script_full_path/key-runner.py"