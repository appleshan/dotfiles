#!/usr/bin/env bash

PIDS=$(pgrep -f "v2raya")

if [ -n "$PIDS" ]; then
  # 如果发现已有进程，pass
  notify-send "🐱 V2RayA is already running, pass" -a V2RayA -t 3000
fi
