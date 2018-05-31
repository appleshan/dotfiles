#!/bin/sh

case "$1" in
    --clean)
        rm -rf ~/.local/share/Trash/files
        rm -rf ~/.local/share/Trash/info
        mkdir ~/.local/share/Trash/files
        mkdir ~/.local/share/Trash/info
        ;;
    *)
        # find ~/.local/share/Trash/files/ -maxdepth 1 | wc -l
        echo $(find ~/.local/share/Trash/files/ -maxdepth 1 | wc -l) -1 | bc
        ;;
esac
