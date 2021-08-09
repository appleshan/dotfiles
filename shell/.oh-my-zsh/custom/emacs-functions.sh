#!/bin/bash

alias e='emacsclient -n'

alias jm='cd $(emacsclient -e "(with-current-buffer (window-buffer (frame-selected-window)) default-directory)" | '"sed -E 's/(^\")|(\"$)//g')"

alias emacs-test='emacs -q --debug-init --load "~/projects-private/emacs-test/init.el"'

# 在Emacs中阅读这些man page
pps_man() {
    emacsclient -t -e "(woman \"$1\")"
}
alias m=pps_man

function edb {
    emacs --debug-init
}

function emacs_pids {
    pgrep -i emacs
}

function kill_all_emacs {
    emacs_pids | xargs kill -9
}
