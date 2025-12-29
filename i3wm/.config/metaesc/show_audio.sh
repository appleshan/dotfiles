#!/usr/bin/env bash
audio=$(pactl list sinks | grep -e '^[[:space:]]Volume:' | tr -sc '0-9%' '\n' | grep % -m 1 2>/dev/null)
mute=$(pactl list sinks | grep 'Mute: yes' 2>/dev/null)
if [ -n "$mute" ];then
    notify-send -t 500 "🎶 Mute"
else
    notify-send -t 500 "🎶 $audio"
fi
