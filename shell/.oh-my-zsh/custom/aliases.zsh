#!zsh
#  ┌─┐┬  ┬┌─┐┌─┐
#  ├─┤│  │├─┤└─┐
#  ┴ ┴┴─┘┴┴ ┴└─┘

# modified commands

# Replace ls with eza for beautiful directory listings
alias l='eza -lbF'
alias lt='eza --tree --icons --level=2'
alias ltd='eza --tree --icons --level=2 --only-dirs'

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

alias mutt='neomutt -F ~/.config/mutt/muttrc'

alias p='parallel'
alias pp='parallel --pipe -k'

alias show-fonts="fc-list | cut -d ' ' -f2 | sort -u"

alias disks='echo "╓───── m o u n t . p o i n t s"; echo "╙────────────────────────────────────── ─ ─ "; lsblk -a; echo ""; echo "╓───── d i s k . u s a g e"; echo "╙────────────────────────────────────── ─ ─ "; df -h;'

alias lsdisk='lsblk -o+FSTYPE,FSSIZE,PARTLABEL,LABEL'

alias grep='grep --color=auto --exclude-dir={.git,.hg,.svn,.cvs,bzr,CVS,target,build,_site,.idea,Pods,taobao-tomcat} --exclude=\*.{ipr,iml,iws,jar,war,zip}'
export GREP_COLOR='mt=07;31'

alias beep='pw-play ~/projects/private/dotfiles/sounds/beep.mp3'

alias vim=nvim

alias rm='echo "This is not the command you are looking for."; false'

# alias docker=podman

# by Felix Yan <https://github.com/felixonmars>
# stat of system update
# 查询archlinux滚了多少次
alias roll='echo $(head -n1 /var/log/pacman.log | cut -d " " -f 1,2) 以来一共滚动更新了 $(grep -c "full system upgrade" /var/log/pacman.log) 次'

# Arch 安装包时校验失败怎么办？
# from https://young-lord.github.io/posts/arch-makepkg-integrity
alias yass=yay --mflags "--skipchecksums --skippgpcheck"
