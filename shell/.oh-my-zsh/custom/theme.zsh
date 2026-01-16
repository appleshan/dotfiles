#!zsh
#  ┌┬┐┬ ┬┌─┐  ┌─┐┬─┐┌─┐┌┬┐┌─┐┌┬┐
#   │ ├─┤├┤   ├─┘├┬┘│ ││││├─┘ │ 
#   ┴ ┴ ┴└─┘  ┴  ┴└─└─┘┴ ┴┴   ┴

# {{ spaceship
# See https://github.com/denysdovhan/spaceship-zsh-theme

# DIR
SPACESHIP_DIR_TRUNC='0' # show only last directory
SPACESHIP_DIR_TRUNC_REPO=false

# GIT
# Wrap git in `git:(...)`
SPACESHIP_GIT_PREFIX='git:('
SPACESHIP_GIT_SUFFIX=") "
SPACESHIP_GIT_SYMBOL="" # disable git prefix

# DOCKER
SPACESHIP_DOCKER_PREFIX="docker:("
SPACESHIP_DOCKER_SUFFIX=") "
SPACESHIP_DOCKER_SYMBOL=""

# uv
SPACESHIP_UV_PREFIX="uv:("
SPACESHIP_UV_SUFFIX=") "

# VENV
SPACESHIP_VENV_PREFIX="venv:("
SPACESHIP_VENV_SUFFIX=") "

# python
SPACESHIP_PYTHON_PREFIX="python:("
SPACESHIP_PYTHON_SUFFIX=") "
SPACESHIP_PYTHON_SYMBOL=""

SPACESHIP_CONDA_PREFIX="conda:("
SPACESHIP_CONDA_SUFFIX=") "
SPACESHIP_CONDA_SYMBOL=""

# golang
SPACESHIP_GOLANG_PREFIX="golang:("
SPACESHIP_GOLANG_SUFFIX=") "
SPACESHIP_GOLANG_SYMBOL=""

# Java
SPACESHIP_JAVA_PREFIX="java:("
SPACESHIP_JAVA_SUFFIX=") "
SPACESHIP_JAVA_SYMBOL=""

# Kotlin
SPACESHIP_KOTLIN_PREFIX="kotlin:("
SPACESHIP_KOTLIN_SUFFIX=") "

ZSH_THEME="spaceship-prompt/spaceship"
# }}

# powerlevel10k
# https://github.com/romkatv/powerlevel10k#oh-my-zsh
# ZSH_THEME="powerlevel10k/powerlevel10k"

# {{ nvm
zstyle ':omz:plugins:nvm' lazy yes
# }}
