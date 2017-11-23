#!/usr/bin/env bash

sudo pacman -S bind-utils
sudo pacman -S unbound

wget ftp://FTP.INTERNIC.NET/domain/named.cache -O ./root.hints
