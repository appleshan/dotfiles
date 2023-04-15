#!/bin/sh

# Polybar Player
# Copyright (C) 2021 Matthew Sirman, Tim Clifford
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or (at your
# option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
# License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

mkdir -p /tmp/polybar-player

# Handle command line options

## Defaults
maxwidth=-1
pushed_metadata_players=""

while [ $# -gt 0 ]; do
	case $1 in
		-m|--maxwidth)
			shift
			if [ $# -lt 1 ]; then
				echo "ERROR: --maxwidth requires an argument"
				exit 1
			fi
			maxwidth=$1
			shift
			if echo $maxwidth | grep -Evq '[0-9]+'; then
				echo "ERROR: maxwidth must be a non-negative integer"
				exit 1
			elif [ $maxwidth -eq 0 ] || [ $maxwidth -eq -1 ]; then
				# This is OK, they are special values
				:
			elif [ $maxwidth -le 3 ]; then
				echo "ERROR: maxwidth must be at least 4"
				exit 1
			fi
			;;
		--use-pushed-metadata)
			shift
			if [ $# -lt 1 ]; then
				echo "ERROR: --use-pushed-metadata requires an argument"
				exit 1
			fi
			pushed_metadata_players="$pushed_metadata_players $1"
			shift
			;;
		*)
			echo "ERROR: Unsupported option"
			exit 1
			;;
	esac
done

title_error="Unknown Title"
artist_error="Unknown Artist"

. "$(dirname "$0")/lib.sh"

# dash has no arrays but i NEEED SPEEED

# format of the "array"
# substring match:icon/name:arbitrary sed command to run on title:options
# currently options only matches "noartist"

# The escaping of the sed command is a nightmare, be warned

regex_url_mappings='
.*youtube.*:%{F#ff5555}%{F-}::noartist
.*twitch.*:%{F#ffffff}%{F-}:s/ - Twitch//:
'

regex_title_mappings="
.* - Twitch::s/ - Twitch//:
"

regex_player_mappings="
spotify:%{F#50fa7b}%{F-}::
mpv:%{F#bd93f9}%{F-}::
firefox:::
chromium:Brave::
vlc:VLC::
"

found_currently_playing=0

if [ -f /tmp/polybar-player/current ]; then
	current_player=$(cat /tmp/polybar-player/current)
else
	current_player=''
fi

# we want to process the current player last for a smooth experience
# sadly -z is a GNUism but oh well
players=$(playerctl -l | sed -z "s/\(.*\)\($current_player\n\)\(.*\)/\1\3\2/")

set_from_map() { # takes $1: map, $2 thing to match on

	# Set separator to a newline character
	# for our fucked up data structure
	IFS="
"
	for map in $1; do
		regex=$( echo $map | sed 's/^\(.*\):\(.*\):\(.*\):\(.*\)/\1/')
		icon=$(  echo $map | sed 's/^\(.*\):\(.*\):\(.*\):\(.*\)/\2/')
		sedcmd=$(echo $map | sed 's/^\(.*\):\(.*\):\(.*\):\(.*\)/\3/')
		option=$(echo $map | sed 's/^\(.*\):\(.*\):\(.*\):\(.*\)/\4/')
		if echo $2 | grep -Eq "$regex"; then
			suffix=$icon
			if ! [ "$sedcmd" = '' ]; then
				title=$(echo $title | sed "$sedcmd")
			fi
			break
		fi
	done
}

for player in $players
do
	if [ "$(get_player_attribute $player status)" = 'Playing' ]; then
		found_currently_playing=1
	else
		if [ $found_currently_playing -eq 1 ]; then
			# We'd prefer an active player and we've already found one
			continue
		fi
	fi
	title="$(get_player_attribute $player title)"
	[ $? -ne 0 ] && title=$title_error

	artist="$(get_player_attribute $player artist)"
	[ $? -ne 0 ] && artist=$artist_error

	if [ "$title" = "$title_error" ] && [ "$artist" = "$artist_error" ]; then
	    continue
	fi

	url=''
	if echo "$player" | grep -q "firefox"; then
		# Process firefox player if we can access it
		if [ -f $HOME/.mozilla/firefox/*.default-release/sessionstore-backups/recovery.jsonlz4 ]
		then
			# Just trust in the black magic please
			# Ignore jq stderr, as it sometimes encounters quoting issues from
			# the firefox json. It will then fall back on the firefox logo.
			url=$(lz4jsoncat $HOME/.mozilla/firefox/*.default-release/sessionstore-backups/recovery.jsonlz4 \
				| jq "$(echo '.windows[] | .tabs[] | .entries[] ' \
					'| select(.title != null) | select(.title ' \
					'| contains("'"$title"'")) ' \
					'| .url')" 2>/dev/null \
				| sed 's/^"//;s/"$//')
		fi
	fi

	current_player=$player
	suffix="${player} (Unknown)" # Default

	set_from_map "$regex_player_mappings" "$player"
	set_from_map "$regex_title_mappings"  "$title"   # Titles take precedence
	set_from_map "$regex_url_mappings"    "$url"     # URLs take even more precedence
done



# write the player to a temp file for the play-pause script
# logic for if current_player = '' is on the other side
echo -n $current_player > /tmp/polybar-player/current

# Don't introduce a trailing - if there's no artist
# Don't include suffix until after comparing to maxwidth
# (because it has ANSI codes in it)
if echo $artist | grep -Eq '^[ \t]*$' \
	|| echo $option | grep -q 'noartist';
then
	out="$title"
else
	out="$title  -  $artist"
fi
if [ $maxwidth -eq 0 ]; then
	echo "  $suffix"
elif [ $maxwidth -ne -1 ] && [ $(echo "$out" | wc -m) -gt $maxwidth ]; then
	echo "  $(echo ${out: 0: $(echo "$maxwidth - 3" | bc -l)})... $suffix"
else
	echo "  $out $suffix"
fi
