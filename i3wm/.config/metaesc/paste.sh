#!/usr/bin/env bash
var1=$1
focus_win=$(xprop -id $(xdotool getactivewindow) | grep WM_CLASS | cut -d'"' -f2)
if [[ "$var1" == 'c' ]]; then
	timestamp=$(date +"%Y/%m/%d-%R")
	if [[ $focus_win =~ emacs|gnome-terminal|urxvt ]]; then
        # gnome-terminal|urxvt need tmux
		sleep 0.2
		xdotool key --clearmodifiers y
		sleep 0.1
		content=$(xclip -selection c -o)
		from=$(xprop -id $(xdotool getactivewindow) | egrep "^WM_NAME" | cut -d'"' -f2)
	elif [[ $focus_win =~ chrome ]]; then
		sleep 0.2
		xdotool key --clearmodifiers ctrl+c
		notify-send 'copied from chrome' -t 300
		# sleep 0.1; content=$(xclip -selection c -o)
		# xdotool key Y; sleep 0.1
		# from=$(xclip -selection c -o)
	elif [[ $focus_win =~ code ]]; then
		sleep 0.2
	    xdotool key --clearmodifiers ctrl+c # not work on terminal
		notify-send 'copied from code' -t 300
    else
		sleep 0.2
	    xdotool key --clearmodifiers ctrl+c # not work on terminal
    fi
    # dump to a note file
	# echo "${content} \"$timestamp : ${from}\"" >> ~/braindump/lib/vocab.org
	# could use xprop to get WM_NAME for source refile
elif [[ "$var1" == 'v' ]]; then
	sleep 0.1
	if [[ $focus_win =~ code|gnome-terminal ]]; then
	    xdotool key --clearmodifiers ctrl+V
	elif [[ $focus_win =~ 'urxvt' ]]; then
	    xdotool key --clearmodifiers ctrl+alt+v
	elif [[ $focus_win =~ emacs ]]; then
	    xdotool key --clearmodifiers p
    else
	    xdotool key --clearmodifiers ctrl+v
    fi
fi
