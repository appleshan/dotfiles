#!/usr/bin/env bash

# https://www.ayautomate.com/blog/best-claude-code-hooks-examples
# 6. Auto-commit on Stop, best for solo builders
# Claude finished a turn. Before you forget, snapshot the state.
# A Stop hook that runs git add -A && git commit -m "wip: claude turn" gives you a reflexive checkpoint.
# If the next turn goes sideways, git reset returns you to known-good.

git add -A && \
git diff --cached --quiet || \
git commit -m "wip: claude turn [skip ci]" --no-verify
