#!/usr/bin/env bash

# https://www.ayautomate.com/blog/best-claude-code-hooks-examples
# 13. Sub-agent ROI tracker, best for parallel teams
# Sub-agents are powerful but easy to misuse: spawning 4 parallel Task agents that each burn 50k tokens for a one-line answer.
# A SubagentStop hook logs every sub-agent run with its duration and token cost so you can spot the freeloaders.

echo "{\"ts\":\"$(date -u +%FT%TZ)\",\"agent\":\"$CLAUDE_SUBAGENT_NAME\",\"duration_s\":$CLAUDE_SUBAGENT_DURATION,\"tokens\":$CLAUDE_SUBAGENT_TOKENS}" >> ~/.claude/subagent-roi.jsonl
