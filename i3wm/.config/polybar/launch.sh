#!/usr/bin/env sh

# Basic script to kill all old bars and launch new.

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
# while pgrep -x polybar >/dev/null; do sleep 1; done
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch top and bottom
# polybar top &
# polybar bottom &

MONITOR=DP1 polybar -l=error -c ~/.config/polybar/config.ini top &
MONITOR=DP1 polybar -l=error -c ~/.config/polybar/config.ini bottom &

echo "Bars launched..."
