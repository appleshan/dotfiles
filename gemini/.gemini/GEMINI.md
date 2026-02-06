# Guidelines

## User Context
- The user prefers Simplified Chinese for conversation.
- The user is a junior front-end engineer and an experienced backend engineer.
- Adjust explanations to the user's knowledge level: clear, concrete, and practical.

## Global Policies

### Language & Writing Policy (Single Source of Truth)
- Conversation (all assistant replies): **Simplified Chinese (简体中文) only**.
- Anything that becomes part of a codebase or engineering artifact must be **English only**, including:
  - Source code, comments, docs
  - Git commits, PRs, issues, changelogs, release notes
- Exception: Chinese may exist only inside localization resources (i18n). Developer-facing text remains English.

### Output Style
- Default to concise answers and minimal steps/commands.
- Expand only when asked, or when risk/ambiguity requires assumptions and verification steps.

### Change Safety & Intent
- If the request is ambiguous, confirm intent and scope before non-trivial changes.
- Prefer minimal diffs; avoid unrelated refactors unless requested.

## Workflows

### Git Workflow (Follow Language & Writing Policy)
- Create commits **only when explicitly requested** by the user.
- Otherwise: keep changes staged locally or provide a patch/diff for review.
- Prefer Conventional Commits style.
- When a multi-paragraph message is needed, use multiple `-m` flags:
  - `git commit -m "feat: add automated deploy pipeline" -m "- Add CI job for image build" -m "- Add SSH-based deploy step"`

### PR Protocol (gh CLI)
- Open PRs only when requested; merge PRs only when explicitly requested.
- Do not use escaped `\n` in `--body` (they render literally).
- Prefer `--body-file` to pass Markdown content.
- Suggested structure:
  - Summary
  - Impact
  - Notes
  - References / Links

## Engineering

### Engineering Principles
- Avoid inventing extra entities/components/abstractions without necessity.
- Use modern best practices by default.
- Add backward compatibility / legacy workarounds only when requested.

### API Design
- Use stable, readable, ASCII identifiers for:
  - paths, parameters, response keys, types, identifiers, error codes/messages
- Follow HTTP semantics:
  - correct methods (GET/POST/PUT/PATCH/DELETE)
  - standard status codes (2xx/4xx/5xx)
  - avoid overusing 200 for errors

### Documentation Standards
- Include: assumptions, setup, usage, verification steps when relevant.
- Avoid time/cost estimates unless the user explicitly requests them.

## Shell Execution & Timeout Handling
When running shell commands or interactive environments (bash/zsh/sh), always:
- Prefer one-shot, non-interactive commands.
- Add safeguards to prevent hanging:
  - use timeouts when appropriate (e.g., `timeout 60s ...`)
  - use `set -euo pipefail` for scripts/snippets when relevant
- If a command may block (e.g., `tail -f`, REPL, servers):
  - explain how to stop it before running (Ctrl+C, kill command, etc.)
- Avoid overusing `.sh` scripts; prefer direct commands and built-in tooling.
