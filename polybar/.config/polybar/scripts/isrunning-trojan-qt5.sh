#!/bin/sh

if [ "$(pgrep shadowsocks2)" ]; then
    echo ""
elif [ "$(pgrep ss-qt5)" ]; then
    echo ""
elif [ "$(pgrep Trojan-Qt5)" ]; then
    echo ""
else
    echo ""
fi
