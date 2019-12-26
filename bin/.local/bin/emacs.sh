#!/bin/zsh
# /usr/bin/emacs --debug-init "$@"

# 在 Emacs 中使用 fcitx 输入法
# @See https://bbs.archlinuxcn.org/viewtopic.php?pid=15534#p15534
env LC_CTYPE="zh_CN.UTF-8" /usr/bin/emacs "$@"

