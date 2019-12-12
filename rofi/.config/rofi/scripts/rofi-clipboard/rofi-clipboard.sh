#!/usr/bin/env bash

scripts_dir="$(dirname $(readlink -f $0))/scripts"
scripts=$(find "$scripts_dir" -mindepth 1 -maxdepth 1 -type f -printf '%f\n')
script=$(rofi -dmenu <<< "$scripts")
if [[ -n "$script" ]]; then
	tmpfile=$(mktemp)
	chmod go-rwx "$tmpfile"
	xclip -o | "$scripts_dir/$script" > "$tmpfile"
	if [[ $? -eq 0 ]]; then
		xclip -i -sel clip < "$tmpfile"
	else
		notify-send -u critical "Something went (horribly) wrong. [$?]"
	fi
	rm "$tmpfile"
fi
