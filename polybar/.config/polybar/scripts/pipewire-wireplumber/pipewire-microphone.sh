#!/bin/sh

status() {
	res=$(wpctl status | grep Sources -A2 | grep vol | cut -d: -f2 | tr -d ] | cut -c2- | sed 's/^0//' | tr -d .)
	if echo "$res" | grep -q MUTED; then
		echo "muted"
	else
		if [[ -n $res ]]; then
	        echo "$res%"
        else
	        echo ""
	    fi
	fi
}

listen() {
	status

	LANG=EN
	pactl subscribe | while read -r event; do
		if echo "$event" | grep -q "source" || echo "$event" | grep -q "server"; then
			status
		fi
	done
}

toggle() {
	ppid=$(wpctl status | grep Sources -A2 | grep vol | cut -d\* -f2 | cut -d. -f1)
	wpctl set-mute $ppid toggle
}

increase() {
	ppid=$(wpctl status | grep Sources -A2 | grep vol | cut -d\* -f2 | cut -d. -f1)
	wpctl set-volume $ppid 1%+
}

decrease() {
	ppid=$(wpctl status | grep Sources -A2 | grep vol | cut -d\* -f2 | cut -d. -f1)
	wpctl set-volume $ppid 1%-
}

zerodb() {
	ppid=$(wpctl status | grep Sources -A2 | grep vol | cut -d\* -f2 | cut -d. -f1)
	wpctl set-volume $ppid 100%
}

case "$1" in
--toggle)
	toggle
	;;
--increase)
	increase
	;;
--decrease)
	decrease
	;;
--zerodb)
	zerodb
	;;
*)
	status
	;;
esac
