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

# Stolen from: https://github.com/jaagr/polybar/issues/763
if type "xrandr"; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        if [ "$m" = "DP1" ]; then
            MONITOR=$m polybar -l=error -c ~/.config/polybar/config.ini top &
            MONITOR=$m polybar -l=error -c ~/.config/polybar/config.ini bottom &
        else
            MONITOR=$m polybar -l=error -c ~/.config/polybar/config.ini bottom &
        fi
    done
else
    polybar -l=error -c ~/.config/polybar/config.ini top &
    polybar -l=error -c ~/.config/polybar/config.ini bottom &
fi

echo "Bars launched..."
