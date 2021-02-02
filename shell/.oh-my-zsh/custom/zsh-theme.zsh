#!zsh

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

# VENV
SPACESHIP_VENV_PREFIX="venv:("
SPACESHIP_VENV_SUFFIX=") "

# PYENV
SPACESHIP_PYENV_PREFIX="python:("
SPACESHIP_PYENV_SUFFIX=") "
SPACESHIP_PYENV_SYMBOL=""

SPACESHIP_CONDA_PREFIX="conda:("
SPACESHIP_CONDA_SUFFIX=") "
SPACESHIP_CONDA_SYMBOL=""

# ZSH_THEME="spaceship-prompt/spaceship"
# }}

# {{ powerlevel9k
POWERLEVEL9K_MODE='awesome-fontconfig'
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline virtualenv pyenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs history time)
POWERLEVEL9K_VCS_BRANCH_ICON=$'\uF126 '
# ZSH_THEME="powerlevel9k/powerlevel9k"
# }}

# powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# {{ dircolors
eval `dircolors ~/.dircolors`
# }}

