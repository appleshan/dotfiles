#!/bin/sh

if [ "$(pgrep -x shadowsocks2)" ]; then
    echo ""
elif [ "$(pgrep -x ss-qt5)" ]; then
    echo ""
elif [ "$(pgrep -x Trojan-Qt5)" ]; then
    echo ""
elif [ "$(pgrep -x qv2ray)" ]; then
    echo ""
elif [ "$(pgrep -x cfw)" ]; then
    echo ""
else
    echo ""
fi

