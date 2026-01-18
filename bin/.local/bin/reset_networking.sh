#!/usr/bin/env bash
#
# This file is used to remember some commands for Wireless Network

# == Statistic commands ==

sudo lshw -C network
ip link show enp86s0
ip link show wlo1
ifconfig
sudo systemd-resolve --statistics

# == Reset commands ==

sudo ifdown -a
sudo ifup -a
sudo /etc/init.d/networking restart
sudo service network-manager restart
sudo systemctl restart NetworkManager
sudo systemd-resolve --flush-caches

