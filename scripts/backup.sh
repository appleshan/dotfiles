#!/usr/bin/env zsh

# Rebuild config structure in $DST
for f in $TARGETS; do
	#移除 f 前面的目录名
	conf=${f#*/}

    #如果 SRC 已经是软链接了，就跳过.
	is_link=$(file $SRC/$conf |grep -c 'link')
	if [[ "$is_link" -eq 1 ]]; then
		continue
	fi

    #备份配置文件
	rsync -a --relative $SRC/./$conf $DST/$f
done

#列出已经安装软件，备份软件名称
pacman -Qne | sort > $ARCHLINUX/pkg_native
pacman -Qm | sort > $ARCHLINUX/pkg_aur
