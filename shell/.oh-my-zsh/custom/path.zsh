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
source ~/.local/bin/z.sh

# ripgrep
export RIPGREP_CONFIG_PATH=~/.config/ripgrep/.ripgreprc

###############
# Emacs Setup #
###############

# export EMACS_HOME=/opt/emacs-25.1

#EMACSLOADPATH=$EMACS_HOME/share/emacs/24.5/lisp
#EMACS_DIR=$EMACS_HOME/share/emacs/24.5
#EMACSDATA=$EMACS_HOME/share/emacs/24.5/etc

#export EMACSLOADPATH EMACS_DIR EMACSDATA

# export EDITOR='emacsclient -a ""'

# emacs安装目录的 bin 文件夹，须要加入 PATH 变量
# export PATH=$EMACS_HOME/bin:$PATH

##############
# Java Setup #
##############

# VERSIONS #
# Oracle JDK 6
# export JAVA_6_HOME=/opt/java/jdk1.6.0_45
# Oracle JDK 7
# export JAVA_7_HOME=/opt/java/jdk1.7.0_60
# Oracle JDK 8
export JAVA_8_HOME=/opt/java/jdk1.8.0_162
# Oracle JDK 12
export JAVA_12_HOME=/opt/java/jdk-12.0.2
# default JDK is 12
export JAVA_HOME=$JAVA_12_HOME
export JRE_HOME=$JAVA_12_HOME/jre

appendpath "$JAVA_HOME/bin"

export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib

export IDEA_JDK=/opt/java/jdk-12.0.2

# Gradle Setup
export GRADLE_OPTS="-Xmx2g -XX:ReservedCodeCacheSize=512m"
# 不添加HOME环境变量，软链接到 /usr/local/bin

# Maven Setup
export MAVEN_OPTS="-Xmx2g -XX:ReservedCodeCacheSize=512m"
# 不添加HOME环境变量，软链接到 /usr/local/bin

#################
# Android Setup #
#################
# export ANDROID_HOME="/opt/android-sdk-linux"
# export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"

#################
# golang        #
#################
#export GOARCH=amd64
#export GOOS=linux

# GOROOT is the location where Go package is installed on your system.
#export GOROOT=/opt/golang/go-1.7.5

# GOPATH is the location of your work directory.
#export GOPATH=~/developer/projects/golang

# 安装目录的 bin 文件夹，须要加入 PATH 变量
#export GOBIN=$GOPATH/bin
#export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

#################
# Oracle Client #
#################

# Oracle Client
#export ORACLE_HOME=/opt/oracle
#export LD_LIBRARY_PATH=/opt/oracle/lib
#export NLS_LANG="SIMPLIFIED CHINESE_CHINA.AL32UTF8"
#export PATH=$ORACLE_HOME/bin:$PATH

#################
# Python        #
#################

# 禁用字节码(.pyc)文件
export PYTHONDONTWRITEBYTECODE=1

if [ `id -u` != '0' ]; then
    # Pipenv 自动在项目目录的 .venv 目录创建虚拟环境
    export PIPENV_VENV_IN_PROJECT=true

    # virtualenvwrapper
    # source ~/.local/bin/virtualenvwrapper.sh
fi

# Pyenv
#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"

# Miniconda
#export MINICONDA_HOME=~/miniconda3
#export PATH=$MINICONDA_HOME/bin:$PATH

# autoenv
# 使用 git 方式安装了 Tarrasch/zsh-autoenv
source ~/.oh-my-zsh/custom/plugins/zsh-autoenv/autoenv.zsh

# pipsi
export PIPSI_HOME=~/.local/venvs/pipsi
appendpath "$PIPSI_HOME/bin"
