#!/bin/bash

alias emacs-test='emacs -q --debug-init --load "~/projects-private/emacs-test/init.el"'

# 在Emacs中阅读这些man page
emacs_man() {
    emacsclient -t -e "(woman \"$1\")"
}
alias m=emacs_man

function edb {
    emacs --debug-init
}

function emacs_pids {
    pgrep -i emacs
}

function kill_all_emacs {
    emacs_pids | xargs kill -9
}
