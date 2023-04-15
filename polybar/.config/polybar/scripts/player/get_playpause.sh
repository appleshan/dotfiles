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

pushed_metadata_players=""

while [ $# -gt 0 ]; do
	case $1 in
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

. "$(dirname "$0")/lib.sh"
if test -f /tmp/polybar-player/current; then
	player="$(cat /tmp/polybar-player/current)"
	case "$(get_player_attribute $player status)" in
		"Playing")
			echo ""
			;;
		"Paused")
			echo ""
			;;
		*)
			echo "X"
			;;
	esac
else
	echo "X"
fi
