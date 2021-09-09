#!/usr/bin/env bash

# dotfiles utility - https://gist.github.com/Jamesits/9bc4adfb1f299380c79e
# Set $DOTFILES to where you want to put your dotfiles.
# then run dotfiles-init someSoftware,
# and it will move all files starting with `.someSoftware` to the correct location
# then link them back,
# Which will produce a directory structure like:
#
# $ tree -aL 2 ~/projects-private/dotfiles
# ~/projects-private/dotfiles :
# ├── dotfiles.sh
# └── shell
#     └── .zshrc
#

# Where to store your actual config files
export DOTFILES=~/projects-private/dotfiles

# List unlinked dotfiles
dotfiles-count() {
    pushd >/dev/null 2>&1 || exit
    cd "$HOME" || exit
    ls -ald .* | grep -v ^l | tee >(wc -l)
    popd >/dev/null 2>&1 || exit
}

# Move and link files named `.something*`
dotfiles-init() {
    pushd >/dev/null 2>&1 || exit
    cd "$HOME" || exit
    ls -ald ."$1"*
    mkdir -p $DOTFILES/"$1"
    mv ."$1"* $DOTFILES/"$1"
    stow --dir=$DOTFILES --target="$HOME" -vv "$1"
    popd >/dev/null 2>&1 || exit
}

# rebuild links - useful when you are recovering settings to a new OS
# run `dotfiles-rebuild *` to rebuild all at once
dotfiles-rebuild() {
    stow --dir=$DOTFILES --target="$HOME" -vv $@
}

# delete
dotfiles-delete() {
    stow --dir=$DOTFILES --target="$HOME" -vv -D $@
}

# dotfiles-rebuild() :
# $ stow -d $HOME/projects-private/dotfiles -t $HOME -vv shell

# usage
# $ dotfiles-rebuild shell

# $ ls -alF | grep "^l"
