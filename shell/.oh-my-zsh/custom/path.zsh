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
source $HOME/.local/bin/z.sh

# ripgrep
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/.ripgreprc

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
# export JAVA_6_HOME=$HOME/bin/java/jdk1.6.0_45
# Oracle JDK 7
# export JAVA_7_HOME=$HOME/bin/java/jdk1.7.0_60
# Oracle JDK 8
export JAVA_8_HOME=$HOME/bin/java/jdk1.8.0_162
# Oracle JDK 11
export JAVA_11_HOME=$HOME/bin/java/jdk-11.0.7-full
# default JDK is 11
export JAVA_HOME=$JAVA_11_HOME
export JRE_HOME=$JAVA_11_HOME/jre

appendpath "$JAVA_HOME/bin"

export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib

export IDEA_JDK=$JAVA_11_HOME

# Gradle Setup
export GRADLE_OPTS="-Xmx2g -XX:ReservedCodeCacheSize=512m"
# 不添加HOME环境变量，软链接到 /usr/local/bin
# ln -s $HOME/bin/java/gradle-6.7/bin/gradle /usr/local/bin

# Maven Setup
export MAVEN_OPTS="-Xmx2g -XX:ReservedCodeCacheSize=512m"
# 不添加HOME环境变量，软链接到 /usr/local/bin
# ln -s $HOME/bin/java/apache-maven-3.6.3/bin/mvn /usr/local/bin

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
#export GOPATH=$HOME/developer/projects/golang

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

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Miniconda
#export MINICONDA_HOME=$HOME/miniconda3
#export PATH=$MINICONDA_HOME/bin:$PATH

# autoenv
# 使用 git 方式安装了 Tarrasch/zsh-autoenv
source $HOME/.oh-my-zsh/custom/plugins/zsh-autoenv/autoenv.zsh

# pipsi
export PIPSI_HOME=$HOME/.local/venvs/pipsi
appendpath "$PIPSI_HOME/bin"

#################
# Node.js       #
#################

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#################
# dotnet-sdk    #
#################

export DOTNET_ROOT=$HOME/bin/dotnet

