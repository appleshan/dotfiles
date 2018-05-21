#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch top and bottom
polybar top &
polybar bottom &

#MONITOR=HDMI-1 polybar top &
#MONITOR=HDMI-2 polybar top &
#MONITOR=HDMI-2 polybar bottom &

echo "Bars launched..."
