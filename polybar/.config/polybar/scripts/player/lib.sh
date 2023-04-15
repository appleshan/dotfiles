#!/bin/sh

get_player_attribute() { # takes $1: player, $2 attribute
	if echo "$pushed_metadata_players" | grep -q "$1\$"; then
		cat "/tmp/polybar-player/$1-$2" 2>/dev/null
		return $?
	else
		if [ "$2" = "title" ] || [ "$2" = "artist" ]; then
			playerctl -p $1 metadata $2
			return $?
		else
			playerctl -p $1 $2
			return $?
		fi
	fi
}

