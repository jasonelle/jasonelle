---
name: rebuild-tools
description: Whenever you modify a source file inside tools/<name>/src/, you MUST rebuild its dist binaries (task <name>.build or task build inside tools/<name>/src) before the change is done, and commit the rebuilt binaries. The dist/ binaries are git-tracked and are what task run steps execute, so skipping a rebuild ships stale artifacts.
---

# rebuild-tools

The committed binaries in `tools/<name>/dist/` are what the Taskfile tasks run.
A source edit in `tools/<name>/src/` without a rebuild leaves the pipeline
executing old code. A stale binary caused the link tool to silently skip the
config/scripts copy into `sources/Application/...` (commit c573882).

## Rules

- After editing any file under `tools/<name>/src/`, run the tool build task:
  `task <name>.build` (which runs `task build` inside `tools/<name>/src`).
- Commit the rebuilt `tools/<name>/dist/<name>-{darwin,linux}-{amd64,arm64}` and
  `<name>-windows-amd64.exe` binaries in the same commit as the source change.
- Rebuild for all four platforms (the build task already does this); do not
  push only the local-arch binary.
- A bare `task <name>` invocation runs the committed binary and is not a build.
  Verify the change took effect with `grep`/`strings` on the binary or by
  running the corresponding test suite (`task test` in `tools/<name>/src`)
  against the new source before rebuilding.
- If a PR only edits `tools/<name>/src/`, call out that the rebuilt binaries
  are included so reviewers know the runnable artifact matches the code.

## Example

Bad: edit `tools/link/src/main.go`, commit the source, stop there.

Good: edit `tools/link/src/main.go`, run `task link.build`, run the tests,
commit source + the four fresh binaries together.

## When to skip

- Docs-only or README changes inside `tools/` do not need a rebuild.
- Binary rebuilt for a cosmetic-only source change (e.g. license header) is
  optional, but the binary and source must always agree.