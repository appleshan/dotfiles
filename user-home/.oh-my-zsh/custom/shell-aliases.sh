#!zsh
# bash_aliases

#-------------------
# Personnal Aliases
#-------------------

# apt-get
#alias aptu="sudo apt update"
#alias aptua="sudo apt upgrade"
#alias apts="sudo apt-cache search"
#alias apti="sudo apt install"
#alias aptr="sudo apt remove"
#alias aptac="sudo apt autoclean"
#alias aptar="sudo apt autoremove"
#alias apti-proxy='sudo apt -o "Acquire::http::Proxy=http://127.0.0.1:18080" install'

# modified commands

# alias more='less'
alias df='df -kTh'
alias dfxfs='df -Th --total -t xfs'

alias tree='tree -C'		# nice alternative to 'ls'

# new commands
alias internet-ip="curl ipinfo.io/ip"
alias local-ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
alias openports='netstat --all --numeric --programs --inet --inet6'

# Pipe my public key to my clipboard.
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# Pretty print the path
alias path='echo $PATH | tr -s ":" "\n"'

alias pc='proxychains4'

alias magit='ec -e "(magit-status \"$(pwd)\")"'

alias wa='which -a'
alias ta='type -a'

# speed up download
alias axel='axel -a -n 10'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias jm='cd $(emacsclient -e "(with-current-buffer (window-buffer (frame-selected-window)) default-directory)" | '"sed -E 's/(^\")|(\"$)//g')"

alias mutt='mutt -F ~/.mutt/.muttrc'

alias w3m='w3m -cookie '

###############################################################################
# Emacs
###############################################################################

alias emacs-test='emacs -q --debug-init --load "~/projects/emacs-test/init.el"'

###############################################################################
# Python
###############################################################################

alias py='python'
alias py2='python2'
alias py3='python3'
alias ipy='ipython'
alias ipy2='ipython2'
alias ipy3='ipython3'

alias prp="pipenv run python"

alias webshare='python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'
