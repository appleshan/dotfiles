# rofi-i3-keybinds
Rofi menu for your i3wm keybinds

## Usage
Run `rofi-i3-keybinds.sh` to get a rofi menu with keybinds parsed from `$HOME/.config/i3/config`. Selecting a keybind will execute that keybind using `xdotool`. If your i3wm config file is located in a different location that can be changed in the script

When parsing your config file, if the parser sees a comment at the end of the keybind line, it will display the comment instead of the command the keybind runs. This can be useful if you want to write summaries of what the command does if it is a long command.

## Requirements
* python3
* xdotool
* rofi

## Screenshots
![](Screenshot%20from%202020-07-23%2012-05-51.png)