#!/bin/sh

## 我自己的基于 rsync 的快照式备份过程
## (cc) marcio rps AT gmail.com

# 配置变量

SRC="/home/alecshan/files/" #dont forget trailing slash!
SNAP="/snapshots/alecshan"
OPTS="-rltgoi --delay-updates --delete --chmod=a-w"
MINCHANGES=20

# 以低优先级运行此进程

ionice -c 3 -p $$
renice +12  -p $$

# 同步

rsync $OPTS $SRC $SNAP/latest >> $SNAP/rsync.log

# 检查是否有足够的变化，如果有
# 则制作一份以日期命名的硬链接副本

COUNT=$( wc -l $SNAP/rsync.log|cut -d" " -f1 )
if [ $COUNT -gt $MINCHANGES ] ; then
        DATETAG=$(date +%Y-%m-%d)
        if [ ! -e $SNAP/$DATETAG ] ; then
                cp -al $SNAP/latest $SNAP/$DATETAG
                chmod u+w $SNAP/$DATETAG
                mv $SNAP/rsync.log $SNAP/$DATETAG
               chmod u-w $SNAP/$DATETAG
         fi
fi
