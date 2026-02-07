# Gemini CLI Development Guidelines

## User Context
- The user prefers Simplified Chinese for conversation.
- The user is a junior front-end engineer and an experienced backend engineer.
- Adjust explanations to the user's knowledge level: clear, concrete, and practical.

## Global Policies

### Language & Writing Policy (Single Source of Truth)
- Conversation (all assistant replies): **Simplified Chinese only**.
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

## 🚨 Critical Principles

### 1. Build the minimal working solution first

- Ship the simplest code that satisfies the requirement
- Skip advanced syntax, optimizations, or abstractions until basic behaviour is verified
- Favor classic, obvious constructs (e.g., `function` over newer syntax) for first pass

### 2. Verify everything

- Confirm APIs, data contracts, and assumptions with real references before coding
- If verification is impossible, pause and escalate instead of guessing
- Base implementations on observed structures, not speculation

### 3. Enforce loose coupling

- Keep each module independent and testable in isolation
- Communicate through clear, narrow interfaces; avoid reaching into other modules' internals
- Prevent shared mutable state and deep dependency chains

### 4. Maintain strict MVC separation

- **Model** handles data and business rules only
- **View** renders UI and styling only
- **Controller** orchestrates models and views only
- Never mix concerns—refactor immediately if layers start to blur

## 🏗️ Architecture Standards

### Module Design

```
✅ GOOD:
- One responsibility per module
- Simple inputs produce simple outputs
- Module can run and be tested alone
- Communicates via basic, well-defined interfaces

❌ BAD:
- Module depends on internal details of others
- Long dependency chains or shared state
- Overly clever patterns where straightforward code works
```

### MVC Implementation

```javascript
// ✅ GOOD - responsibilities are isolated
// Model
class UserModel {
  getUser(id) { return userData; }
}

// View
function UserView(user) {
  return `<div class="user">${user.name}</div>`;
}

// Controller
function UserController() {
  const user = model.getUser(1);
  return view(user);
}

// ❌ BAD - concerns mixed together
class User {
  getUser(id) {
    return `<div style="color:red">${userData.name}</div>`;
  }
}
```

## Workflows

### 📋 Implementation Workflow

#### Step 1: Minimal Working Version

```
1. Identify the essential behaviour
2. Implement it with the simplest code
3. Validate it works end-to-end
4. Stop—do not add extras yet
```

#### Step 2: Modularize

```
1. Split into Model, View, Controller modules
2. Keep files focused on a single purpose
3. Define lightweight interfaces between pieces
4. Test each module independently
```

#### Step 3: Enhance Gradually

```
1. Add improvements one at a time
2. Preserve loose coupling and MVC boundaries
3. Refactor promptly when complexity grows
```

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

### 🛠️ Practical Patterns

#### Feature kickoff

```javascript
// Minimal version
function getUsers() {
  return [{ id: 1, name: "John" }];
}

// Structured version
// models/user.js
function getUsers() {
  return [{ id: 1, name: "John" }];
}

// views/userList.js
function renderUsers(users) {
  return users.map(u => `<li>${u.name}</li>`).join('');
}

// controllers/userController.js
function showUsers() {
  const users = getUsers();
  return renderUsers(users);
}
```

#### Module communication

```javascript
// ✅ GOOD - simple contract
export function processData(input) {
  return { result: input * 2 };
}

// ❌ BAD - unnecessary complexity
export class ComplexProcessor {
  constructor(dependency1, dependency2, config) {}
}
```

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

### Shell Execution & Timeout Handling
When running shell commands or interactive environments (bash/zsh/sh), always:
- Prefer one-shot, non-interactive commands.
- Add safeguards to prevent hanging:
  - use timeouts when appropriate (e.g., `timeout 60s ...`)
  - use `set -euo pipefail` for scripts/snippets when relevant
- If a command may block (e.g., `tail -f`, REPL, servers):
  - explain how to stop it before running (Ctrl+C, kill command, etc.)
- Avoid overusing `.sh` scripts; prefer direct commands and built-in tooling.

## ⚠️ Delivery Priorities

1. Functionality: Does the minimal version work?
2. Separation: Are MVC boundaries untouched?
3. Simplicity: Are modules lightweight and independent?
4. Clarity: Can another developer grasp it instantly?

## 🚫 Avoid

- Using bleeding-edge features when basic syntax will do
- Complex dependency-injection or service locators
- Embedding view logic in models
- Sharing mutable state across modules
- Over-engineering straightforward problems
- Layering features before the core path is verified

## 💡 Quick Checklist

- [ ] What is the simplest way to deliver this?
- [ ] Are Model, View, Controller cleanly separated?
- [ ] Is every module independent and easy to test?
- [ ] Am I relying on proven patterns?

## 🔧 Debug Playbook

1. Remove recent additions until the bug disappears
2. Narrow the issue to a single module
3. Fix with the smallest possible change
4. Re-test each module in isolation
