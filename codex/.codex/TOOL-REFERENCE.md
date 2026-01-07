# TOOL-REFERENCE.md

> 📖 **返回核心指南**: [AGENTS.md](./AGENTS.md)

本文档提供 Codex CLI 工具的详细语法和使用说明。

---

## Shell Commands

### 核心原则

When using the shell, you must adhere to the following guidelines:

- When searching for text or files, prefer using `rg` or `rg --files` respectively because `rg` is much faster than alternatives like `grep`. (If the `rg` command is not found, then use alternatives.)
- Read files in chunks with a max chunk size of 250 lines. Do not use python scripts to attempt to output larger chunks of a file. Command line output will be truncated after 10 kilobytes or 256 lines of output, regardless of the command used.

---

## apply_patch

Your patch language is a stripped‑down, file‑oriented diff format designed to be easy to parse and safe to apply. You can think of it as a high‑level envelope:

```
*** Begin Patch
[ one or more file sections ]
*** End Patch
```

Within that envelope, you get a sequence of file operations.
You MUST include a header to specify the action you are taking.
Each operation starts with one of three headers:

***** Add File: <path>** - create a new file. Every following line is a + line (the initial contents).
***** Delete File: <path>** - remove an existing file. Nothing follows.
***** Update File: <path>** - patch an existing file in place (optionally with a rename).

May be immediately followed by ***** Move to: <new path>** if you want to rename the file.
Then one or more "hunks", each introduced by @@ (optionally followed by a hunk header).
Within a hunk each line starts with:

- for inserted text,
* for removed text, or
  space ( ) for context.
  At the end of a truncated hunk you can emit ***** End of File.

### Formal Syntax (BNF)

```
Patch := Begin { FileOp } End
Begin := "*** Begin Patch" NEWLINE
End := "*** End Patch" NEWLINE
FileOp := AddFile | DeleteFile | UpdateFile
AddFile := "*** Add File: " path NEWLINE { "+" line NEWLINE }
DeleteFile := "*** Delete File: " path NEWLINE
UpdateFile := "*** Update File: " path NEWLINE [ MoveTo ] { Hunk }
MoveTo := "*** Move to: " newPath NEWLINE
Hunk := "@@" [ header ] NEWLINE { HunkLine } [ "*** End of File" NEWLINE ]
HunkLine := (" " | "-" | "+") text NEWLINE
```

### Complete Example

A full patch can combine several operations:

```
*** Begin Patch
*** Add File: hello.txt
+Hello world
*** Update File: src/app.py
*** Move to: src/main.py
@@ def greet():
-print("Hi")
+print("Hello, world!")
*** Delete File: obsolete.txt
*** End Patch
```

### Tool Invocation

You can invoke apply_patch like:

```json
{
  "command": [
    "apply_patch",
    "*** Begin Patch\n*** Add File: hello.txt\n+Hello, world!\n*** End Patch\n"
  ]
}
```

### Important Reminders

It is important to remember:

- You must include a header with your intended action (Add/Delete/Update)
- You must prefix new lines with `+` even when creating a new file

---

## update_plan

A tool named `update_plan` is available to you. You can use it to keep an up‑to‑date, step‑by‑step plan for the task.

### Creating a Plan

To create a new plan, call `update_plan` with a short list of 1‑sentence steps (no more than 5-7 words each) with a `status` for each step (`pending`, `in_progress`, or `completed`).

### Updating Progress

When steps have been completed, use `update_plan` to mark each finished step as `completed` and the next step you are working on as `in_progress`. There should always be exactly one `in_progress` step until everything is done. You can mark multiple items as complete in a single `update_plan` call.

### Completion

If all steps are complete, ensure you call `update_plan` to mark all steps as `completed`.
