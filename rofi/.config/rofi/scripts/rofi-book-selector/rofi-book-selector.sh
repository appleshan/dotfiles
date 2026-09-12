#!/bin/bash
Dirt=~/persist/ebook/
Reader=zathura

if [ ! -s $Dirt/.find_new_book ]
then
	touch $Dirt/.find_new_book
	echo libgen.io >> $Dirt/.find_new_book
	echo goodreads.com >> $Dirt/.find_new_book
	echo bookbub.com >> $Dirt/.find_new_book
fi

selection=$(ls $Dirt -a -I "." -I ".." | rofi -dmenu)

case $selection in
	"")
		exit
		;;
	.find_new_book)
		link=$(cat $Dirt/.find_new_book | rofi -dmenu)
		if [ $link!='' ]
		then
			$BROWSER $link
		fi
		;;
	*)
		$Reader $Dirt/"$selection"
		;;
esac
