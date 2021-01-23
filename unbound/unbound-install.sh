#!/usr/bin/env bash

sudo pacman -S bind-utils
sudo pacman -S unbound

# sudo wget ftp://FTP.INTERNIC.NET/domain/named.cache -O /etc/unbound/root.hints
# or
sudo curl -o /etc/unbound/root.hints https://www.internic.net/domain/named.cache
