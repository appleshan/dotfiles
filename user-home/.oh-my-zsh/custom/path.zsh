#!zsh

# PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

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
# export JAVA_6_HOME=/opt/java/jdk1.6.0_43
# Oracle JDK 7
# export JAVA_7_HOME=/opt/java/jdk1.7.0_60
# Oracle JDK 8
export JAVA_8_HOME=/opt/java/jdk1.8.0_162
# default JDK is 8
export JAVA_HOME=$JAVA_8_HOME
export JRE_HOME=$JAVA_8_HOME/jre

export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib

# SWITCHING #
# alias java6="export JAVA_HOME=$JAVA_6_HOME;export PATH=$JAVA_HOME/bin:$PATH"
# alias java7="export JAVA_HOME=$JAVA_7_HOME;export PATH=$JAVA_HOME/bin:$PATH"
# alias java8="export JAVA_HOME=$JAVA_8_HOME;export PATH=$JAVA_HOME/bin:$PATH"

#################
# Android Setup #
#################
# export ANDROID_HOME="/opt/android-sdk-linux"
# export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"

###############
# Maven Setup #
###############

# VERSIONS #
export MAVEN_HOME=/opt/java/apache-maven-3.5.2
export MAVEN_OPTS="-Xmx2g -XX:ReservedCodeCacheSize=512m"
export PATH=$MAVEN_HOME/bin:$PATH

#################
# Eclipse Setup #
#################
# export ECLIPSE_HOME=/opt/eclipse-jee-neon/eclipse
# export PATH=$ECLIPSE_HOME:$PATH

###############
# Ajoke Setup #
###############
# export AJOKE_DIR=~/git/java/ajoke
# export export PATH=$AJOKE_DIR/bin:$PATH
# export PERL5LIB="$AJOKE_DIR/etc/perl:$PERL5LIB";

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

#if [ `id -u` != '0' ]; then
##     export VIRTUALENV_USE_DISTRIBUTE=1        # <-- Always use pip/distribute
#    export WORKON_HOME=$HOME/.virtualenvs       # <-- Where all virtualenvs will be stored
#    source /usr/local/bin/virtualenvwrapper.sh
#    export PIP_VIRTUALENV_BASE=$WORKON_HOME
#    export PIP_RESPECT_VIRTUALENV=true
#fi
