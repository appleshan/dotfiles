#!/bin/bash

# source me in your script or .bashrc/.zshrc if wanna use cecho
# source '/path/to/shell-prompt.sh'

#################
# Shell Prompt  #
#################

# old prompt
# PS1='${debian_chroot:+($debian_chroot)}[\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]]\$ '

# 理想中的 shell prompt
# ┌─(~)─────────────────────────────────────────────────(appleshan@miniubuntu)─┐
# └─(11:29:22)─(NN$)─> command goes here...              <─(2013-08-02, 星期五)─┘
#
# 实际开发成了这样子：
# ┌─(~)─(appleshan@miniubuntu)
# └─(11:29:22)─(NN$)─> command goes here...

# 字体要求：Source Code Pro
# Define some colors first:
 COLOR_NONE="\[\033[0m\]"
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[1;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[1;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
#LIGHT_GRAY="\[\033[0;37m\]"
    MAGENTA="\[\e[1;35m\]"
       CYAN="\[\e[1;36m\]"

    # the ✓ unicode symbol for a zero status
    success="\342\234\223"
      # the ✗ unicode symbol for a nonzero status
      error="\342\234\227"
      # ─
      minus="\342\224\200"
     # → 要正常显示这个符号，字体大小必须是12号.
   # arrows="→"
  #┌
# quarter_1="\342\224\214"
  #└
# quarter_2="\342\224\224"
  #╭
  quarter_1="╭"
  #╰
  quarter_2="╰"

SKULL_AND_CROSSBONES="\342\230\240"

COMMAND_EXEC_RESULT="(\$(if [[ \$? == 0 ]]; then echo '${YELLOW}${success}'; else echo '${RED}${error}'; fi)${GREEN})"

# user:
if [[ $(id -ur) == 0 ]]; then # root
    user_status="${LIGHT_RED}${SKULL_AND_CROSSBONES} \u ${SKULL_AND_CROSSBONES}${BLUE}@${LIGHT_RED}\h"
    user_prompt="#"
else # other user
    user_status="${MAGENTA}\u${BLUE}@${GREEN}\h"
    user_prompt="$"
fi

## Parses out the branch name from .git/HEAD:
function find_git_branch () {
    # echo "find_git_branch()"
    local dir=. head
    until [ "$dir" -ef / ]; do
        if [ -f "$dir/.git/HEAD" ]; then
            head=$(< "$dir/.git/HEAD")
            if [[ $head = ref:\ refs/heads/* ]]; then
                git_branch=" → git:${head#*/*/}"
            elif [[ $head != '' ]]; then
                git_branch=" → git:(detached)"
            else
                git_branch=" → git:(unknow)"
            fi
            return
        fi
        dir="../$dir"
    done
    git_branch=''
}

# PWD_DIR="(${CYAN}\w${YELLOW}${git_branch}${GREEN})"
PWD_DIR="(${CYAN}\w${GREEN})"

function print_minus_chars() {
    # echo "${PWD/#$HOME/\~}"
    pwd_show_text="(${PWD/#$HOME/\~}$git_branch)"
    pwd_length=${#pwd_show_text}
    user_status_length=${#user_status}
# echo "$pwd_show_text"
# echo "$pwd_length"
# echo "$user_status_length"

# 155 142
    line_length=155
    let minus_char_num=line_length - pwd_length - user_status_length - 3
# echo "$minus_char_num"

    minus_chars=""
    for i in $( seq 1 "$minus_char_num" ); do minus_chars+=$minus; done
# echo "$minus_chars"
}

PROMPT_COMMAND="find_git_branch; $PROMPT_COMMAND"

PS1="${GREEN}${quarter_1}${minus}"$PWD_DIR"${minus}"$COMMAND_EXEC_RESULT"${minus}(${user_status}${GREEN})\n${GREEN}${quarter_2}${GREEN}${minus}(${WHITE}\t${GREEN})${minus}(${LIGHT_GREEN}\#${user_prompt}${GREEN})${minus}> ${COLOR_NONE}"
