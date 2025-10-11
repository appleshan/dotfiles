#!/usr/bin/env zsh

for f in $TARGETS; do
	#移除 f 前面的目录名
	conf=${f#*/}
	
	if [ -e $SRC/$conf ]; then
		echo -ne "\033[35m[Warning]\033[0m File or directory '$SRC/$conf' exists! Override? (y/n) "
		read answer
		if [ -z "$answer" -o "${answer:0:1}x" = 'yx' -o "${answer:0:1}" = 'Yx' ]; then
			rm -rf $SRC/$conf
		else
			continue
		fi
	else
		parent=$(dirname $conf)
		if [ ! -d $SRC/$parent ]; then
			mkdir -p $SRC/$parent
		fi
	fi
    ln -s $DST/$f $SRC/$conf

done

