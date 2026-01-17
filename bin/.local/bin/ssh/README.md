# Distribute SSH-KEYS 

Automated Script to Copy SSH-KEYS to multiple servers for passwordless authentication

#Script  to copy SSH keys to the target servers Recursively
It also sets the proper permissions on to the target directory

--Takes the serverlist file as inline argument

--Prompts for password and uses it for all the servers (Password will not be stored)

--The serverlist file should have IP/hostnames one per line

--No Trailing empty/carriage return line is accepted

--Script verifies for the existance of "id_rsa.pub" under /home/sysops/.ssh/

--and exits if no file detected

# Pre-requisites
--       Need Open-SSH and sshpass installed

--       Need to have "id_rsa.pub" already generated

#How to use?
(1) Install - "sudo apt-get install openssh-server sshpass"

(2) Login as required user

(3) Generate the kesy
Use "ssh-keygen -t rsa" to generate ssh-keys
or
```
keygen.sh
```

(4) Download the script - Go to /tmp/
```
wget https://github.com/appleshan/dotfiles/tree/stow/bin/.local/bin/ssh/copy_ssh_key.sh
```

(5) Set permissions
```
chmod +x copy_ssh_key.sh
```

(6) Make sure to have a file (ex - serverlist.txt) created and populated with all the IP/hostnames "one-per-line"

(7) Execute the script: 
```
./copy_ssh_key.sh /path/to/serverlist.txt
```

(8) Follow the onscreen instructions

(9) Cheers...!!

