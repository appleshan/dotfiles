#!/bin/sh
##################################################################
####														  ####
####														  ####
####														  ####
####  Script to copy ssh id_rsa.pub to multiple servers		  ####
####														  ####
####														  ####
####														  ####
####														  ####
####														  ####
##################################################################
##
##
#
# Script  to copy SSH keys to the target servers Recursively
# It also sets the proper permissions on to the target directory
# Takes the serverlist file as inline argument
#
# The serverlist file should have IP/hostnames one per line
# No Trailing empty/carriage return line is accepted
#
# Script verifies for the existance of "id_rsa.pub" under /home/sysops/.ssh/
# and exits if no file detected
#
# Pre-requisites
#       Need Open-SSH installed
#       Need to have "id_rsa.pub" already generated
#       Use ssh-keygen -t rsa to generate if not done already
echo "*********************************************"
if [ $# -eq 0 ]; then
    echo "Usage: $0<SPACE><SERVER_LIST>"
    echo "*********************************************"
    exit 1
elif [ -r $1 ]; then
    if [ -s $1 ]; then
        SERVER_LIST=$1
    else
        echo "The provided file '$1' is empty....!!!"
        echo "Check the file, add the servers and come back later...!!!"
        echo "*********************************************"
        exit 1
    fi
else
    echo "Either the specified file '$1' doesn't exist
        or the file is not readable!
            or the file is empty....!!!
                Check the file path/permission!"
    echo "*********************************************"
    exit 1
fi
echo "*********************************************"
##
#####           Function to prompt for user attention
echo "*********************************************"
echo "This script will try to copy the ssh keys to the servers provided in the list"
echo "This script will terminate If Open-SSH is not installed"
echo "This script will abort if SSH keys are not yet generated"
echo "Press 'y' to continue
Press 'n' to abort the script"
echo "*********************************************"
SCRIPT=$0
read item
case "$item" in
n | N)
    echo "Aborting the '$SCRIPT' script......"
    exit 1
    ;;
y | Y)
    echo "Continuing the '$SCRIPT' script"
    for i in {1..4}; do
        echo -n "-->"
        sleep 1
    done
    ;;
*)
    echo "Not an answer"
    ;;
esac
##
# Checking the pre-requisites
if [ -r ~/.ssh/id_rsa.pub ]; then
    echo ""
    echo "SSH-KYS exist...We are good to go..."
else
    echo "Either Open-SSH is not installed or
        the SSH-KEYS are not yet generated
        or the file '~/.ssh/id_rsa.pub' doesn't exist
        or the file is not readable!

        (1) Install Open-SSH or Check the file path/permission!.....
        (2) Generate the SSH-KEYS using 'ssh-keygen -t rsa'
        (3) and run the script again....
        Aborting the script $0 now......"
    exit 1
fi
##
LOG_FILE="/var/tmp/sshreport.log"
#SERVER_LIST="/var/tmp/serverlist"
touch $LOG_FILE && chmod 777 $LOG_FILE
chmod 777 $SERVER_LIST
PASS=""
##
# Get the proper universal service account
echo "*********************************************"
echo "I am going to use $USER as a service account for
SSH-Key distribution to all of the servers mentined
in the $SERVER_LIST
Press 'y' to continue
Press 'n' to provide different service account
Press 'c' to abort the script"
echo "*********************************************"
read item
case "$item" in
n | N)
    echo "Please type the service account......"
    read USR
    read -s -p "Enter the password for $USR: " PASS
    ;;
    #exit 1;;
y | Y)
    echo "Continuing with the '$USER' as service account......"
    read -s -p "Enter the password for $USER: " PASS
    USR=$USER
    echo ""
    for i in {1..4}; do
        echo -n "-->"
        sleep 1
    done
    ;;
c | C)
    echo "Aborting the script '$0'......"
    exit 1
    ;;
*)
    echo "Not an answer"
    ;;
esac
echo ""
#echo "Password is $PASS";
## Initializing the loop
DATE=$(date)
echo "================{$DATE}===================" >>$LOG_FILE
for server in $(cat $SERVER_LIST); do
    printf "%-20s\n"
    echo "==================================="
    echo "-----------------------------------" >>$LOG_FILE
    echo $server >>$LOG_FILE
    sshpass -p "$PASS" ssh-copy-id -i ~/.ssh/id_rsa.pub $USR@$server
done
