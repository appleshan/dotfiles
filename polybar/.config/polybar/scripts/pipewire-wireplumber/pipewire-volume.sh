#!/bin/sh

check() {
	vol1=$(wpctl status | grep Sinks -A2 | grep vol | cut -d: -f2 | tr -d ])
	if [ -z "$vol1" ]; then
	    return "0"
    else
	    return "1"
    fi
}

status() {
    ss=$(check)
	if [[ $ss == "0" ]]; then
	    return
	fi

	vol2=$(wpctl status | grep Sinks -A2 | grep vol | cut -d: -f2 | tr -d ] | cut -c2- | sed 's/^0//' | tr -d .)
	if echo "$vol2" | grep -q MUTED; then
		echo "󰖁 muted"
	else
		if [[ -n $vol2 ]]; then
	        echo "󰕾 $vol2%"
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
	ppid=$(wpctl status | grep Sinks -A2 | grep vol | cut -d\* -f2 | cut -d. -f1)
	wpctl set-mute $ppid toggle
}

increase() {
	ppid=$(wpctl status | grep Sinks -A2 | grep vol | cut -d\* -f2 | cut -d. -f1)
	wpctl set-volume $ppid 1%+
}

decrease() {
	ppid=$(wpctl status | grep Sinks -A2 | grep vol | cut -d\* -f2 | cut -d. -f1)
	wpctl set-volume $ppid 1%-
}

zerodb() {
	ppid=$(wpctl status | grep Sinks -A2 | grep vol | cut -d\* -f2 | cut -d. -f1)
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
