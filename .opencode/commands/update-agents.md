---
description: Update AGENTS.md with the latest project changes.
---

Update AGENTS.md to reflect the latest state of the project.
see https://opencode.ai/docs/rules/ and https://agents.md/#examples for additional examples and use context7 mcp if available for any relevant additional 
information needed.

## Sources of truth

- `Taskfile.yml` for the Commands section: tasks, aliases, and descriptions.
- `.opencode/command/` for custom opencode commands (Directory layout).
- `.editorconfig`, `antora/Dockerfile`, `.github/workflows/` for Conventions
  and Build notes.
- `sources/xcode` for sources used in xcode project.
- `sources/android` for sources used in android project.
- `tools` for tools

## Steps

1. Read AGENTS.md, Taskfile.yml, and the tracked repository layout.
2. Check the "Commands" section against Taskfile.yml: every task must be
   listed as `task <name>` (alias `<a>`): <desc>. Add missing tasks and
   remove any that no longer exist.
3. Check the "Directory layout" section against tracked files; add a bullet
   for `.opencode/command/` (custom opencode commands) if missing.
4. Check "Conventions" and "Build notes" only against their sources of truth
   above; update them if a source contradicts them.
5. Update AGENTS.md only where it drifted. Preserve its structure, tone,
   and conventions. Do not modify any other files.

## Output

List the changes you made to AGENTS.md.
