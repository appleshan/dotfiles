# Claude Code + Codex MCP Collaboration

## Core Principles

1. **Separation of Concerns**: CC = brain (planning, search, decisions), Codex = hands (code generation, refactoring)
2. **Codex-First Strategy**: Default to Codex for code tasks, CC only for trivial changes (<20 lines) and non-code work
3. **Zero-Confirmation Flow**: Pre-defined boundaries, auto-execute within limits
4. **MANDATORY Parameter Requirement**: ALWAYS use `model: "gpt-5-codex"`, `sandbox: "danger-full-access"`, `approval-policy: "on-failure"` when calling Codex MCP - NO EXCEPTIONS

---

## Core Rules

### Linus's Three Questions (Pre-Decision)
1. Is this a real problem or imagined? → Reject over-engineering
2. Is there a simpler way? → Always seek simplest solution
3. What will this break? → Backward compatibility is iron law

### CC Responsibilities
- ✅ Plan, search (WebSearch/Glob/Grep), decide, coordinate Codex
- ✅ Trivial changes only: typo fixes, comment updates, simple config tweaks (<20 lines)
- ❌ No final code in planning phase
- ❌ Delegate all code generation/refactoring to Codex (even simple tasks)

### Quality Standards
- Simplify data structures over patching logic
- No useless concepts in task breakdown
- >3 indentation levels → redesign
- Complex flows → reduce requirements first

### Safety
- Check API/data breakage before changes
- Explain new flow compatibility
- High-risk changes only with evidence
- Mark speculation as "assumption"

### Codex Participation Priority
**IMPORTANT**: Maximize Codex involvement for all code-related tasks
- ✅ Single function modification → Codex
- ✅ Adding a new method → Codex
- ✅ Refactoring logic → Codex
- ✅ Bug fixes → Codex
- ❌ Only skip Codex for: typo fixes, comment-only changes, trivial config tweaks (<20 lines)

**CRITICAL**: Always use `model: "gpt-5-codex"`, `sandbox: "danger-full-access"`, `approval-policy: "on-failure"` when calling Codex MCP
- ✅ Correct: `model: "gpt-5-codex"`, `sandbox: "danger-full-access"`, `approval-policy: "on-failure"`
- ❌ Wrong: Any other model, sandbox, or approval-policy value
- This is a MANDATORY requirement, not optional

---

## MCP Invocation

### CRITICAL REQUIREMENT
**MUST ALWAYS include `model: "gpt-5-codex"`, `sandbox: "danger-full-access"`, `approval-policy: "on-failure"`** - This is NON-NEGOTIABLE
- Every single Codex MCP call MUST include all three parameters with these exact values
- Do NOT use any other model, sandbox, or approval-policy values
- Do NOT omit any of these parameters
- Do NOT use mcp__codex__codex_reply, You can only call mcp__codex__codex to append all tasks in the prompt.

### Session Management

// First call
mcp__codex__codex({
  model: "gpt-5-codex",
  sandbox: "danger-full-access",
  approval-policy: "on-failure",
  prompt: "<structured prompt>"
})


### Auto-Confirmation
**✅ Auto-continue**: Modify existing files (in scope), add tests, run linter, read-only ops
**⛔ Pause**: Modify package.json deps, change public API, delete files, modify configs

---

## Routing Matrix (Codex-First)

| Task | Executor | Trigger | Reason |
|------|----------|---------|--------|
| Code changes | **Codex** | Any code modification (functions, logic, components) | Strong generation, always prefer Codex |
| Single-file edit | **Codex** | Even <50 lines if involves logic/code | Better code understanding |
| Multi-file refactor | **Codex** | >1 file with code changes | Global understanding |
| New feature | **Codex** | Any new functionality | Strong generation |
| Bug fix | **Codex** | Need trace or logic fix | Strong search + fix |
| Trivial changes | **CC** | Typos, comments, simple configs (<20 lines) | Too simple for Codex |
| Non-code work | **CC** | Pure .md/.json/.yaml (no logic) | No code generation needed |
| Architecture | **CC** | Pure design decision | Planning strength |

**Decision Flow**: User Request → Linus 3Q → Assess → **Default to Codex for code** → Only CC for trivial/non-code

---

## Workflow (4 Phases)

### 1. Info Collection (CC)
- WebSearch: latest docs/practices
- Glob/Grep: analyze code structure
- Output: context report (tech stack, files, patterns, risks)

### 2. Task Planning (CC Plan Mode)

## Tech Spec
Goal: [one sentence]
Tech: [lib/framework]
Risks: [breaking changes]
Compatibility: [how to ensure]

## Tasks
- [ ] Task 1: [desc] | Executor: CC/Codex | Files: [paths] | Constraints: [limits] | Acceptance: [criteria]
- [ ] Task 2: ...


### 3. Execution (Codex-First)
- **Codex (Default)**: All code-related tasks → Call with structured prompt, **MUST include `model: "gpt-5-codex"`, `sandbox: "danger-full-access"`, `approval-policy: "on-failure"`**, save conversationId, monitor
- **CC (Exception Only)**: Trivial non-code work → Edit/Write tools for typos, pure docs, simple configs (<20 lines)

**CRITICAL**: Every Codex MCP call MUST include these three parameters with exact values - this is non-negotiable

### 4. Validation
- [ ] Functionality ✓ | Tests ✓ | Types ✓ | Performance ✓ | No API break ✓ | Style ✓
- Codex runs checks → CC decides → If issues, back to Phase 3

---

## Codex Prompt Template (MUST USE)

## Context
- Tech Stack: [lang/framework/version]
- Files: [path]: [purpose]
- Reference: [file path for pattern/style]

## Task
[Clear, single, verifiable task]
Steps: 1. [step] 2. [step] 3. [step]

## Constraints
- API: Don't change [signatures]
- Performance: [metrics]
- Style: Follow [reference]
- Scope: Only [files]
- Deps: No new dependencies

## Acceptance
- [ ] Tests pass (`npm test`)
- [ ] Types pass (`tsc --noEmit`)
- [ ] Linter pass (`npm run lint`)
- [ ] [Project-specific]

---

## Anti-Patterns (AVOID)

| Pattern | Problem | Fix |
|---------|---------|-----|
| **Using wrong model** | **CRITICAL ERROR - Using non-gpt-5-codex model** | **ALWAYS use `model: "gpt-5-codex"` - NO EXCEPTIONS** |
| Missing sandbox parameter | **MANDATORY breach - Codex runs without `sandbox: "danger-full-access"`** | **ALWAYS set `sandbox: "danger-full-access"`** |
| Missing approval-policy parameter | **MANDATORY breach - Codex runs without `approval-policy: "on-failure"`** | **ALWAYS set `approval-policy: "on-failure"`** |
| CC doing code work | Waste Codex's strength | Use Codex for all code changes (even simple) |
| No boundaries | High failure, breaks code | Structured prompt required |
| Confirmation loops | Low efficiency | Pre-define auto boundaries |
| Ignoring Codex for "simple" edits | Miss code quality improvements | Default to Codex unless trivial (<20 lines typo/comment) |
| Vague tasks | Codex can't understand | Specific, measurable, verifiable |
| Ignore compatibility | Break user code | Explain in Constraints |

---

## Success Metrics

**Efficiency**: 90% auto (no manual confirm) | <2min avg cycle | >80% first-time success
**Quality**: Zero API break | Test coverage maintained | No performance regression
**Experience**: Clear breakdown | Transparent progress | Recoverable errors

---

## Optional Config

# Retry
max-iterations: 3
retry-strategy: exponential-backoff

# Presets
context-presets:
  react: { tech: "React 18 + TS", test: "npm test", lint: "npm run lint" }
  python: { tech: "Python 3.11 + pytest", test: "pytest", lint: "ruff" }

# Checklist
review: [tests, types, linter, perf, api-compat, style]

# Fallback
fallback:
  codex-fail-3x: { action: switch-to-cc, notify: "3 fails, manual mode" }
  api-break: { action: abort, notify: "API break detected" }
