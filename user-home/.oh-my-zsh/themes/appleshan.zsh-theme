# user, host, full path, and time/date
# on two lines for easier vgrepping
# entry in a nice long thread on the Arch Linux forums: http://bbs.archlinux.org/viewtopic.php?pid=521888#p521888

function hg_prompt_info {
    hg prompt --angle-brackets "\
<hg:%{$fg[magenta]%}<branch>%{$reset_color%}><:%{$fg[magenta]%}<bookmark>%{$reset_color%}>\
</%{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}>\
%{$fg[red]%}<status|modified|unknown><update>%{$reset_color%}<
patches: <patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied(%{$reset_color%})>>" 2>/dev/null
}

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}✱"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}➦"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%}✂"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[blue]%}✈"
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}"

function mygit() {
  if [[ "$(git config --get oh-my-zsh.hide-status)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
    echo "${YELLOW} → $ZSH_THEME_GIT_PROMPT_PREFIX${YELLOW}${ref#refs/heads/}$(git_prompt_short_sha)${YELLOW}$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

function retcode() {
  local LAST_EXIT_CODE=$?
  if [[ $LAST_EXIT_CODE -ne 0 ]]; then
    echo "${RED}${error}";
  else
    echo "${YELLOW}${success}";
  fi
}

user="%n"
host="%m"

# Define some colors first:
 COLOR_NONE="\033[0m"
        RED="\033[0;31m"
     YELLOW="\033[1;33m"
      GREEN="\033[0;32m"
       BLUE="\033[1;34m"
  LIGHT_RED="\033[1;31m"
LIGHT_GREEN="\033[1;32m"
      WHITE="\033[1;37m"
 LIGHT_GRAY="\033[0;37m"
    MAGENTA="\e[1;35m"
       CYAN="\e[1;36m"
     PURPLE="%{\e[0;34m%}%B"

# the ✓ unicode symbol for a zero status
success="✓"
  # the ✗ unicode symbol for a nonzero status
  error="✗"
  # ─
  minus="─"
 # → / ➔
APPLESHAN_PROMPT_SYMBOL='→'
#┌
#quarter_1="\342\224\214"
#└
#quarter_2="\342\224\224"
#╭
 quarter_1="╭"
#╰
 quarter_2="╰"

# alternate prompt with git & hg
PROMPT=$'%{\e[0;34m%}%B${quarter_1}${minus}(%b%{\e[0m%}${user}%{\e[1;30m%}@%{\e[0m%}%{\e[0;36m%}${host}%{\e[0;34m%}%B)%b%{\e[0;34m%}%B${minus}%b%{\e[0;34m%}%B(%b%{\e[1;37m%}%~%{\e[0;34m%}%B$(mygit)$(hg_prompt_info)%{\e[0;34m%}%B)
%{\e[0;34m%}%B${quarter_2}${minus}%{\e[0;34m%}%B(%b%{\e[0;33m%}'%D{"%Y-%m-%d %I:%M:%S"}%b$'%{\e[0;34m%}%B)${minus}(%i)${minus}${APPLESHAN_PROMPT_SYMBOL}%b '
PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '

