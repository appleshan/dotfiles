#!/bin/sh

# 基本的快照式 rsync 备份脚本

# 配置
OPT="-aPh"
LINK="--link-dest=/snapshots/alecshan/last/" 
SRC="/home/alecshan/"
SNAP="/snapshots/alecshan/"
LAST="/snapshots/alecshan/last"
date=`date "+%Y-%b-%d:_%T"`

# 运行 rsync 以创建快照
rsync $OPT $LINK $SRC ${SNAP}$date

# 删除指向上一个快照的符号链接
rm -f $LAST

# 创建到最新快照的新符号链接，以便下次备份到硬链接
ln -s ${SNAP}$date $LAST
