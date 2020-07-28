#!/bin/bash

remaining="<SNIPPED SPACE-SEPERATED LIST OF IP ADDRESSES"

colorize() {
    case $1 in
        green)
            echo -e "\e[92m$2\e[0m"
            ;;
        red)
            echo -e "\e[91m$2\e[0m"
            ;;
    esac
}

for ccu in $remaining
do
    response=$(ping -c 1 $ccu)
    if [[ $response == *"100% packet loss"* ]]
    then
        colorize red $ccu
    else
        colorize green $ccu
    fi
done
