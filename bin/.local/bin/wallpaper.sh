#!/bin/bash
shopt -s nullglob

# 参见 https://leburger.gitlab.io/posts/vim-transparent-background/
# manjaro i3 自動切換桌面壁纸
# Manjaro 預設使用 nitrogen 來管理背景桌布，在它的 cli 有 --random 選項能夠使用，非常方便。

# 壁纸放置目录 如需更改壁纸目录请更改该目录为相应的存放目录
# ~/persist/pictures/wallpaper/

# 另外一种脚本写法
while true; do
    nitrogen --set-zoom --random ~/persist/pictures/wallpaper/

    #更换间隔时间 15m即是15分钟
    sleep 15m
done
