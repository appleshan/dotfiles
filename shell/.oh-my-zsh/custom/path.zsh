#!zsh

# Append our default paths
appendpath () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    appendpath "$HOME/.local/bin"
fi

# z - jump around
# @see https://github.com/rupa/z
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

# ripgrep
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/.ripgreprc

PROJECT_PATHS=(~/projects/ai-coding/ ~/projects/private/ ~/projects/working/)

################
# lazyworktree #
################

source ~/.shell/functions/lazyworktree.zsh

jt() { worktree_jump $(git rev-parse --show-toplevel) "$@"; }
_jt() { _worktree_jump $(git rev-parse --show-toplevel); }
compdef _jt jt

alias pl='worktree_go_last $(git rev-parse --show-toplevel)'

###############
# Perl5       #
###############

PATH="$HOME/bin/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="$HOME/bin/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="$HOME/bin/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"$HOME/bin/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=$HOME/bin/perl5"; export PERL_MM_OPT;

##############
# Java Setup #
##############

# VERSIONS #
# Oracle JDK 8
# export JAVA_8_HOME=$HOME/bin/java/jdk1.8.0_212
# Oracle JDK 17
# export JAVA_17_HOME=$HOME/bin/java/jdk-17.0.6
# Azul Zulu Builds of OpenJDK
# Java 8 (LTS)
export JAVA_8_HOME=$HOME/bin/java/zulu8.90.0.19-ca-jdk8.0.472-linux_x64
# Java 11 (LTS)
export JAVA_11_HOME=$HOME/bin/java/zulu11.84.17-ca-jdk11.0.29-linux_x64
# Java 17 (LTS)
export JAVA_17_HOME=$HOME/bin/java/zulu17.62.17-ca-jdk17.0.17-linux_x64
# Java 21 (LTS)
export JAVA_21_HOME=$HOME/bin/java/zulu21.46.19-ca-jdk21.0.9-linux_x64
# Java 25 (LTS)
export JAVA_25_HOME=$HOME/bin/java/zulu25.30.17-ca-jdk25.0.1-linux_x64

# default JDK is 25
export JAVA_HOME=$JAVA_25_HOME
export JRE_HOME=$JAVA_25_HOME/jre

appendpath "$JAVA_HOME/bin"

export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib

# Gradle Setup
export GRADLE_OPTS="-Xmx2g -XX:ReservedCodeCacheSize=512m"
# 不添加HOME环境变量，软链接到 /usr/local/bin
# ln -s $HOME/bin/java/gradle-6.7/bin/gradle /usr/local/bin

# Maven Setup
export MAVEN_OPTS="-Xmx2g -XX:ReservedCodeCacheSize=512m"
# 不添加HOME环境变量，软链接到 /usr/local/bin
# ln -s $HOME/bin/java/apache-maven-3.9.12/bin/mvn /usr/local/bin

#################
# Android Setup #
#################
# export ANDROID_HOME="/opt/android-sdk-linux"
# export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"

#################
# golang        #
#################
export GOARCH=amd64
export GOOS=linux

# GOROOT is the location where Go package is installed on your system.
export GOROOT=/usr/lib/go

# GOPATH is the location of your work directory.
export GOPATH=$HOME/projects/golang

# 安装目录的 bin 文件夹，须要加入 PATH 变量
export GOBIN=$GOPATH/bin
export PATH="$PATH:$(go env GOROOT)/bin:$(go env GOBIN)"

export GO111MODULE=on
export GOPROXY="https://goproxy.cn,direct"
export GOSUMDB=goproxy.cn/sumdb/sum.golang.org

#################
# Python        #
#################

# 禁用字节码(.pyc)文件
export PYTHONDONTWRITEBYTECODE=1

#################
# Node.js       #
#################

source /usr/share/nvm/init-nvm.sh

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

#################
# dotnet-sdk    #
#################

export DOTNET_ROOT=$HOME/bin/dotnet

# podman
export SUPPRESS_BOLTDB_WARNING=true


#################
# FZF           #
#################

export FZF_DEFAULT_COMMAND="fd --hidden --follow -I --exclude={Pods,.git,.idea,.sass-cache,node_modules,build} --type f"
export FZF_DEFAULT_OPTS="
--color=dark
--color=fg:#707a8c,bg:-1,hl:#3e9831,fg+:#cbccc6,bg+:#434c5e,hl+:#5fff87
--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
--height 60%
--layout reverse
--preview-window 'hidden:right:60%'
--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -N -C {}) 2> /dev/null | head -500'
--bind ',:toggle-preview'
--border
--cycle
"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS=$FZF_DEFAULT_OPTS
export FZF_CTRL_R_OPTS="
--layout=reverse
--sort
--exact
--preview 'echo {}'
--preview-window down:3:hidden:wrap
--bind ',:toggle-preview'
--cycle
"

export FZF_ALT_C_OPTS="--preview 'tree -N -C {} | head -500'"
export FZF_TMUX_OPTS="-d 60%"
export FZF_COMPLETION_TRIGGER='**'


#################
# claude        #
#################

export PATH="$PATH:$HOME/.claude/bin"

#################
# rustup        #
#################

# 长期启用镜像源加速 rustup 下载
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

export PATH="$PATH:$HOME/.cargo/bin"

#################
# grok          #
#################

export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
