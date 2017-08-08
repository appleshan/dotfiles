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
alias cat='pygmentize -O style=monokai -f console256 -g'
alias diff='colordiff'              # requires colordiff package
alias grep='grep --color=auto \
--exclude-dir=.cvs \
--exclude-dir=.git \
--exclude-dir=.hg \
--exclude-dir=.svn \
--exclude-dir=target \
--exclude-dir=build \
--exclude-dir=_site \
--exclude-dir=.idea \
--exclude-dir=taobao-tomcat \
--exclude=\*.ipr \
--exclude=\*.iml \
--exclude=\*.iws \
--exclude=\*.jar'
# alias more='less'
alias df='df -kTh'
alias dfxfs='df -Th --total -t xfs'
alias du='du -kh -c'
# alias md='mkdir -p -v'
alias nano='nano -w'
alias ping='ping -c 5'
alias tree='tree -C'		# nice alternative to 'ls'
alias cd..="cd .."
alias ..='cd ..'
#alias ...='cd ../..'
#alias ....='cd ../../..'
#alias .....='cd ../../../..'
#alias ......='cd ../../../../..'

# new commands
alias da='date "+%A, %B %d, %Y [%T]"'
alias du1='du --max-depth=1'
alias hist='history | grep $1'      # requires an argument
alias internet-ip="curl ipinfo.io/ip"
alias local-ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
alias openports='netstat --all --numeric --programs --inet --inet6'
alias pg='ps aux | head -n1; ps aux | grep -i'

# The 'ls' family (this assumes you use the GNU ls)
alias ls='ls --show-control-chars --color=auto -hF'
#alias l='ls -CF'
#alias ll='ls -alFh'
#alias la='ls -Al'          # show hidden files
alias lx='ls -lXB'         # sort by extension
alias lk='ls -lSr'         # sort by size
alias lc='ls -lcr'		     # sort by change time
alias lu='ls -lur'		     # sort by access time
alias lr='ls -lR'          # recursive ls
alias lt='ls -ltr'         # sort by date
alias lm='ls -al |more'    # pipe through 'more'

# safety features
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'                    # 'rm -i' prompts for every file
#alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

alias unrar='unrar x'
alias wget='wget -c'

# Pipe my public key to my clipboard.
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# Pretty print the path
alias path='echo $PATH | tr -s ":" "\n"'

alias pc='proxychains4'

alias magit='ec -e "(magit-status \"$(pwd)\")"'

#alias cd='source $HOME/.dacecd/dcd.sh'
#alias cdl='$HOME/.dacecd/dcd;source $HOME/.dacecd/command.sh'

#alias htop='xtitle Processes on $HOST && htop'

alias wa='which -a'
alias ta='type -a'
alias tailf='tail -f'

# speed up download
alias axel='axel -a -n 10'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias jm='cd $(emacsclient -e "(with-current-buffer (window-buffer (frame-selected-window)) default-directory)" | '"sed -E 's/(^\")|(\"$)//g')"

alias mutt='mutt -F ~/.mutt/.muttrc'

alias w3m='w3m -cookie '

###############################################################################
# Python
###############################################################################

alias py='python'
alias py2='python2'
alias py3='python3'
alias ipy='ipython'
alias ipy2='ipython2'
alias ipy3='ipython3'

alias webshare='python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'
