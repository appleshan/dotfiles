#!/bin/sh

TOKEN=${file:/home/appleshan/Dropbox/keys/git-credentials/github-appleshan.token}

notifications=$(curl -fs https://api.github.com/notifications?access_token=$TOKEN | jq ".[].unread" | grep -c true)

if [ "$notifications" -gt 0 ]; then
    echo " $notifications"
else
    echo " 0"
fi
