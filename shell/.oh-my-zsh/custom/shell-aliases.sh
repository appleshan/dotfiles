#!zsh
# bash_aliases

#-------------------
# Personnal Aliases
#-------------------

# modified commands

# Replace ls with eza for beautiful directory listings
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first --header'
alias la='eza -la --icons --group-directories-first --header'
alias lt='eza --tree --icons --level=2'
alias ltd='eza --tree --icons --level=2 --only-dirs'

# Extended eza aliases
alias l='eza -lbF --git --icons'                # list with git status
alias llm='eza -lbGd --git --sort=modified'     # long list, modified date sort
alias lls='eza -lbhHigmuSa --time-style=long-iso --git --color-scale'  # full details

# alias more='less'
alias df='df -kTh'
alias dfxfs='df -Th --total -t xfs'

# new commands
alias internet-ip="curl ipinfo.io/ip"
alias openports='netstat --all --numeric --programs --inet --inet6'

# Pipe my public key to my clipboard.
#alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# Pretty print the path
alias path='echo $PATH | tr -s ":" "\n"'

# 在终端中运行magit就会调用Emacs并在当前目录下运行magit-status
alias magit='ec -e "(magit-status \"$(pwd)\")"'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias mutt='mutt -F ~/.mutt/.muttrc'

alias p='parallel'
alias pp='parallel --pipe -k'

alias show-fonts="fc-list | cut -d ' ' -f2 | sort -u"

alias disks='echo "╓───── m o u n t . p o i n t s"; echo "╙────────────────────────────────────── ─ ─ "; lsblk -a; echo ""; echo "╓───── d i s k . u s a g e"; echo "╙────────────────────────────────────── ─ ─ "; df -h;'

alias lsdisk='lsblk -o+FSTYPE,FSSIZE,PARTLABEL,LABEL'

alias grep='grep --color=auto --exclude-dir={.git,.hg,.svn,.cvs,bzr,CVS,target,build,_site,.idea,Pods,taobao-tomcat} --exclude=\*.{ipr,iml,iws,jar,war,zip}'
export GREP_COLOR='mt=07;31'

alias beep='aplay ~/projects-private/dotfiles/sounds/beep-07.wav'

alias vim=nvim

alias rm='echo "This is not the command you are looking for."; false'

# alias docker=podman

###############################################################################
# Python
###############################################################################

alias py='python'
alias py2='python2'
alias py3='python3'
alias ipy='ipython'
alias ipy2='ipython2'
alias ipy3='ipython3'
