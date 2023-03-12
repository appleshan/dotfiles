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
SPACESHIP_PYTHON_PREFIX="python:("
SPACESHIP_PYTHON_SUFFIX=") "
SPACESHIP_PYTHON_SYMBOL=""

SPACESHIP_CONDA_PREFIX="conda:("
SPACESHIP_CONDA_SUFFIX=") "
SPACESHIP_CONDA_SYMBOL=""

# ZSH_THEME="spaceship-prompt/spaceship"
# }}

# powerlevel10k
# https://github.com/romkatv/powerlevel10k#oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"

# {{ history-search-multi-word
zstyle ":history-search-multi-word" page-size "20"                     # Number of entries to show (default is $LINES/3)
zstyle ":history-search-multi-word" highlight-color "fg=yellow,bold"   # Color in which to highlight matched, searched text (default bg=17 on 256-color terminals)
zstyle ":plugin:history-search-multi-word" synhl "yes"                 # Whether to perform syntax highlighting (default true)
zstyle ":plugin:history-search-multi-word" active "underline"          # Effect on active history entry. Try: standout, bold, bg=blue (default underline)
zstyle ":plugin:history-search-multi-word" check-paths "yes"           # Whether to check paths for existence and mark with magenta (default true)
zstyle ":plugin:history-search-multi-word" clear-on-cancel "no"        # Whether pressing Ctrl-C or ESC should clear entered query
# }}

# {{ nvm
zstyle ':omz:plugins:nvm' lazy yes
# }}
