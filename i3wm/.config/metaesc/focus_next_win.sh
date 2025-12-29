#!/usr/bin/env bash

. $(dirname "${BASH_SOURCE[0]:-$0}")/utils.sh

nums=$(number_of_windows_in_workspace)

if [ $nums == "1" ]; then
    if [[ $(get_active_win_name) =~ [Ee]macs ]]; then
		# 只专注于当前窗口下的 emacs 
        xdotool key --clearmodifiers ctrl+x o
		# emacsclient -e "(other-window 1)"
    # "main-tmux" is set in i3 config
	elif [[ $(get_active_win_name) =~ "main-tmux" ]]; then
		# 切换 tmux pane
		tmux select-pane -t :.+
    fi
else
    focus_next_win_in_workspace
fi
