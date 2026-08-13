#!/usr/bin/env bash

# https://www.ayautomate.com/blog/best-claude-code-hooks-examples
# 15. Auto-add to TODO file, best for memory
# Claude leaves // TODO: comments mid-session and forgets them.
# A PostToolUse hook that grep's new edits for TODO lines and appends them (with file + line number) to a project-level TODO.md turns those scattered notes into a real backlog.

FILE="$CLAUDE_TOOL_INPUT_file_path";
grep -nE 'TODO:' "$FILE" 2>/dev/null | awk -v f="$FILE" -F: '{print \"- \" f \":\" $1 \" - \" substr($0, index($0,$3))}' >> TODO.md;
sort -u -o TODO.md TODO.md
