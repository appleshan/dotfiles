#!/bin/sh

# 基本的快照式 rsync 备份脚本

# 配置

#移动硬盘 1TB，mount到了这个目录
ROOT_DIR="/run/media/alecshan/Ventoy"

OPT="-aPh"
LINK="--link-dest=$ROOT_DIR/backup/snapshots/last/"
SRC="/home/alecshan/"
SNAP="$ROOT_DIR/backup/snapshots/"
LAST="/snapshots/last"
date=`date "+%Y-%b-%d:_%T"`

# 运行 rsync 以创建快照
rsync $OPT $LINK $SRC "${SNAP}${date}"

# 删除指向上一个快照的符号链接
rm -f "$LAST"

# 创建到最新快照的新符号链接，以便下次备份到硬链接
ln -s "${SNAP}${date}" "$LAST"
