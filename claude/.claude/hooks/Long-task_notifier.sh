#!/usr/bin/env bash

# https://www.ayautomate.com/blog/best-claude-code-hooks-examples
# 3. Long-task notifier, best for async work
# Claude Code emits a Notification event when it is waiting on user input or has been idle for a stretch.
# 长时间运行的Claude Code会话可能持续数分钟。与其盯着终端看，不如在会话结束时收到通知。

# 在macOS使用osascript触发原生通知。
# 对于Linux，将osascript行替换为notify-send "Claude Code" "Session ended"。
# 对于Slack通知，使用webhook：
# curl -s -X POST "$SLACK_WEBHOOK_URL" \
#   -H 'Content-type: application/json' \
#   -d '{"text": "Claude Code session ended"}'

# Read JSON input from Claude Code hook
input=$(cat)

# Extract message from JSON (basic parsing)
message=$(echo "$input" | grep -o '"message":"[^"]*"' | cut -d'"' -f4)
title="Claude Code"

# Terminal bell - triggers VSCode visual bell icon
printf '\a'

# Send OS notification
if [[ "$OSTYPE" == "darwin"* ]]; then
    osascript -e "display notification \"${message}\" with title \"${title}\" sound name \"Glass\""
elif command -v notify-send &> /dev/null; then
    notify-send "${title}" "${message}" -u normal -i terminal
fi
