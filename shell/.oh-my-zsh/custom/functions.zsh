#!zsh

# source me in your script or .bashrc/.zshrc if wanna use cecho
# source '/path/to/functions.sh'

export LC_ALL=zh_CN.UTF-8
export LESSCHARSET=utf-8

# 控制 ls 显示的时间格式
export TIME_STYLE='+%Y/%m/%d %H:%M:%S'

export TIMEFORMAT=$'\nreal %3R\tuser %3U\tsys %3S\tpcpu %P\n'

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
# leading space hides commands from history
export HISTCONTROL=$HISTCONTROL:ignorespace
# no duplicate entries
export HISTCONTROL=$HISTCONTROL:ignoredups

# @See https://blog.lilydjwg.me/2013/7/3/manually-save-read-zsh-history-entries.39852.html
# 不保留重复的历史记录项
setopt hist_ignore_all_dups
# 在命令前添加空格，不将此命令添加到记录文件中
setopt hist_ignore_space
# 在多个 zsh 中及时共享历史记录
setopt SHARE_HISTORY

# The FIGNORE environment variable is nice when you want TAB completion
# to ignore files or folders with certain suffixes, e.g.:
export FIGNORE=~:.o:.svn:.git:.bak:.swp:.elc:.swa:.pyc:.a:.class:.la:.mo:.obj:.pyo

# @see http://www.talug.org/events/20030709/cmdline_history.html
# If you include the expression "[ \t]*" in the HISTIGNORE string,
# you cansuppress history recording at will for any given command
# just by starting with a space!
# Larger bash history (allow 32³ entries; default is 500)
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"   # mem/file sync

# Disable options:
unset MAILCHECK       # I don not want my shell to warn me of incoming mail

#export TERM=rxvt-unicode-256color
#export TERMINAL=rxvt-unicode-256color

# Termite
export TERM=xterm-termite
if [[ $TERM == xterm-termite ]]; then
  source /etc/profile.d/vte.sh
fi

# Automatically start tmux
export ZSH_TMUX_AUTOSTART=true

function twa() {
    echo "================================================================================"
    echo "type -a:\n"
    # type buildin command can output which file the function is definded. COOL!
    type -a "$@"
    echo "--------------------------------------------------------------------------------"
    echo "which -a:\n"
    # which buildin command can output the function implementation. COOL!
    which -a "$@"
    echo "================================================================================"
}

# Speed up SSH X11 Forwarding
function sshx()
{
    ssh -X -C -c blowfish-cbc,arcfour $@
}

# build ssh tunnel
function ssht()
{
    ssh -qTnNfD 7070 $@
}

function bye () {
    sudo shutdown -h now
}

# {{ gpg
encrypt () { gpg -ac --no-options "$1"; }
decrypt () { gpg --no-options "$1"; }
# }}

# Print working file.
#
#     henrik@Henrik ~/.dotfiles[master]$ pwf ackrc
#     /Users/henrik/.dotfiles/ackrc
function pwf {
    echo "$PWD/$1"
}

# Create directory and cd to it.
#
#     henrik@Nyx /tmp$ mcd foo/bar/baz
#     henrik@Nyx /tmp/foo/bar/baz$
function mcd {
    mkdir -p "$1" && cd "$1"
}

# SSH to the given machine and add your id_rsa.pub or id_dsa.pub to authorized_keys.
#
#     henrik@Nyx ~$ sshkey hyper
#     Password:
#     sshkey done.
function sshkey {
    ssh $1 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys" < ~/.ssh/id_?sa.pub  # '?sa' is a glob, not a typo!
    echo "sshkey done."
}

# Create a data URI from a file and copy it to the pasteboard
datauri() {
    local mimeType=$(file -b --mime-type "$1")
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8"
    fi
    printf "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')" | pbcopy | printf "=> data URI copied to pasteboard.\n"
}

function myip() # get IP adresses
{
    myip=`w3m http://ipecho.net/plain`
    echo "${myip}"
}

function ii()   # get current host related info
{
    echo -e "\nYou are logged on $HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\nUsers logged on:$NC " ; w -h
    echo -e "\nCurrent date :$NC " ; date
    echo -e "\nMachine stats :$NC " ; uptime
    echo -e "\nMemory stats :$NC " ; free -h
    # my_ip 2>&- ;
    echo -e "\nLocal IP Address :$NC" ; myip
    echo
}

# finds directory sizes and lists them for the current directory
dirsize ()
{
    du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
        egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
    egrep '^ *[0-9.]*M' /tmp/list
    egrep '^ *[0-9.]*G' /tmp/list
    rm -rf /tmp/list
}

# xclip has some problem with my emacs, so I use xsel for everything

function gclip() {
    if [ $OS_NAME == CYGWIN ]; then
        getclip $@;
    elif [ $OS_NAME == Darwin ]; then
        pbpaste $@;
    else
        if [ -x /usr/bin/xsel ]; then
            xsel -ob $@;
        else
            if [ -x /usr/bin/xclip ]; then
                xclip -o $@;
            else
                echo "Neither xsel or xclip is installed!"
            fi
        fi
    fi
}

function pclip() {
    if [ $OS_NAME == CYGWIN ]; then
        putclip $@;
    elif [ $OS_NAME == Darwin ]; then
        pbcopy $@;
    else
        if [ -x /usr/bin/xsel ]; then
            xsel -ib $@;
        else
            if [ -x /usr/bin/xclip ]; then
                xclip -selection c $@;
            else
                echo "Neither xsel or xclip is installed!"
            fi
        fi
    fi
}

function xtitle ()
{
    case "$TERM" in
        *term | rxvt)
            echo -n -e "\033]0;$*\007" ;;
        *)
        ;;
    esac
}

function big() {
    # find files and sort by size, full path is printed
    find -name "$*" -type f -printf "`pwd`%P %s\n"|sort -k2,2n
}

function pdf {
    if [ -f '/usr/bin/evince' ];then
        evince $@
    fi
}

proxy() {
    if [[ "${http_proxy:-NOTSET}" != "NOTSET" ]]; then
        unset http_proxy && unset https_proxy;
        echo "No proxy.";
    else
        export http_proxy=http://localhost:18080 && https_proxy=http://localhost:18080;
        echo "proxy = $http_proxy";
    fi;
}

# ------------------------------------------------------------
# Define useful commands
# ------------------------------------------------------------

# {{ @see http://samray.xyz/%E5%A6%82%E4%BD%95%E5%9C%A8-Linux%20%E4%B8%8B%E6%8F%90%E9%AB%98%E5%B7%A5%E4%BD%9C%E6%95%88%E7%8E%87
# SSH 免密码代理
function config_ssh_login_key(){
    if [ $# -lt 3 ];then
    echo "Usage: $(basename $0) -u user -h hostname -p port"
    kill -INT $$
    fi
    #if public/private key doesn't exist ,generate public/private key 
    if [ -f ~/.ssh/id_rsa ];then
    echo "public/private key exists"
    else
    ssh-keygen -t rsa
    fi
    while getopts :u:h:p: option
    do
    case "$option" in
            u) user=$OPTARG;;
            h) hostname=$OPTARG;;
            p) port=$OPTARG;;
            *) echo "Unknown option:$option";;
    esac
    done

    if [ -z "$port" ];then
    port=22
    fi
    #check whether it is the first time to run this script and whether authorized_keys exists
    # ssh_host_and_user="$1@$2"
    authorized_keys="$HOME/.ssh/authorized_keys"
    printf "$user@$hostname's password:";read -r -s password
    if sshpass -pv $password ssh -p "$port" "$user@$hostname" test -e "$authorized_keys";then
    echo "authorized key exists"
    kill -INT $$
    else
    sshpass -p $password ssh  $user@$hostname -p $port "mkdir -p ~/.ssh;chmod 0700 .ssh"
    sshpass -p $password scp -P $port  ~/.ssh/id_rsa.pub $user@$hostname:~/.ssh/authorized_keys
    # ssh-copy-id "$user@$hostname -p $port"
    fi
}
# 脚本用法
# config_ssh_login_key -u samray -h 192.168.199.127 -p 666

# 生成若干位的密钥
# generate key
function gkey(){
    if [ -n "$1" ];then
     local length="$1"
    else
     local length=32
    fi
    OS_NAME=$(uname)
    if [ $OS_NAME = "Darwin" ]; then
     LC_CTYPE=C cat /dev/urandom |tr -cd "[:alnum:]"|head -c "$length";echo
    else
     cat /dev/urandom |tr -cd "[:alnum:]"|head -c "$length";echo
    fi
}
# 脚本用法
# gkey
# or
# gkey 64

# 复制命令行输出
# 需要安装 xsel 或者是 xclip 命令
OS_NAME=$(uname)
function pclip() {
    if [ $OS_NAME = "CYGWIN" ]; then
    putclip "$@";
    elif [ $OS_NAME = "Darwin" ]; then
    pbcopy "$@";
    else
    if [ -x /usr/bin/xsel ]; then
        xsel -ib "$@";
    else
        if [ -x /usr/bin/xclip ]; then
        xclip -selection c "$@";
        else
        echo "Neither xsel or xclip is installed!"
        fi
    fi
    fi
}
# 脚本用法：
# gkey|pclip

function ppgrep() {
    if [[ $1 == "" ]]; then
        PERCOL=peco
    else
        PERCOL="peco --query $1"
    fi
    ps aux | eval $PERCOL | awk '{ print $2 }'
}

function ppkill() {
    if [[ $1 =~ "^-" ]]; then
        QUERY=""            # options only
    else
        QUERY=$1            # with a query
        [[ $# > 0 ]] && shift
    fi
    ppgrep $QUERY | xargs kill $*
}

# 复制当前文件路径或者是目录路径

# 复制当前目录下的某个文件路径：
function pwdf() {
    local current_dir=`pwd`
    local copied_file=`find $current_dir -type f -print |peco`
    echo -n $copied_file |pclip;
}

# 复制当前目录的路径：
function pwdp() {
    pwd|pclip;
}

# }}

# directory LS
dls () {
    ls -l | grep "^d" | awk '{ print $8 }' | tr -d "/"
}

function dotfiles_directory() {
    echo $(dirname `readlink -f ~/.zshrc | xargs dirname`)
}

function current_shell() {
    which "$(ps -p $$ | tail -1 | awk '{print $NF}' | sed 's/\-//')"
}

function localip {
    case `uname` in
        'Darwin')
            ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'
            ;;
        'Linux')
			ip -4 addr | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127.0.0.1 | head -n 1
			# This was a nicer solution, but it returns ipv6 addresses on
            # machines that have them:
			# hostname --ip-address
            ;;
    esac
}

# Run `dig` and display the most useful info
function digga() {
	dig +nocmd "$1" any +multiline +noall +answer;
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
function getcertnames() {
	if [ -z "${1}" ]; then
		echo "ERROR: No domain specified.";
		return 1;
	fi;

	local domain="${1}";
	echo "Testing ${domain}…";
	echo ""; # newline

	local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
		| openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);

	if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
		local certText=$(echo "${tmp}" \
			| openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
			no_serial, no_sigdump, no_signame, no_validity, no_version");
		echo "Common Name:";
		echo ""; # newline
		echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
		echo ""; # newline
		echo "Subject Alternative Name(s):";
		echo ""; # newline
		echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
			| sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
		return 0;
	else
		echo "ERROR: Certificate not found.";
		return 1;
	fi;
}

# `ltree` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function ltree() {
	tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

###############################################################################
# Java
###############################################################################

switchJavaNetProxy() {
    [ -z "$JAVA_OPTS_BEFORE_NET_PROXY"] && {
        export JAVA_OPTS_BEFORE_NET_PROXY="$JAVA_OPTS"
        export JAVA_OPTS="$JAVA_OPTS -DproxySet=true -DsocksProxyHost=127.0.0.1 -DsocksProxyPort=7070"
        echo "turn ON java net proxy!"
    }|| {
        export JAVA_OPTS="$JAVA_OPTS_BEFORE_NET_PROXY"
        unset JAVA_OPTS_BEFORE_NET_PROXY
        echo "turn off java net proxy!"
    }
}

###############################################################################
# Git
###############################################################################

# Commit the current changes and push to the current branch
function pushme {
  br=`git branch | grep "*"`
  git add --all
  if (($# > 1)); then
    params=''
    for i in $*;
    do
        params=" $params $i"
    done
    git commit -m "$params"
  else
    git commit -m "$1"
  fi
  git push origin ${br/* /}
}
