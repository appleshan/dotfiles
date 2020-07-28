#!/bin/bash

#Basic network ping tool to check for online hosts

if [ "$1" == "" ]
then
    echo "Pingtool"
    echo "Network ping tool to check for online hosts"
    echo ""
    echo "Usage: ./pingtool.sh [network]"
    echo "Example: ./pingtool.sh 192.168.1"

else
    echo "[+] Starting Network Scan"

    for host in `seq 1 254`; do
        ping -c 1 -W 1 $1.$host | grep "64 bytes"
    done

    echo "[+] Network Scan Complete"
fi
