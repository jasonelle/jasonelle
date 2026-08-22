---
description: Update CHANGELOG.md from git commit messages.
---

Update the top section of `CHANGELOG.md` from the project's git commit
messages, following Keep a Changelog.

## Sources of truth

- `git log` commit subjects (gitmoji + conventional commit format).
- The top version section (`## [...]`) of `CHANGELOG.md` is the section to
  update.
- The previous version section (the next `## ` header) provides the base
  reference for the commit range.

## Steps

1. Read `CHANGELOG.md` and identify the top version section and the previous
   version section below it.
2. Determine the commit range:
   - If `$ARGUMENTS` contains a range (e.g. `v3.0.4..HEAD`), use it as-is.
   - Otherwise use `<previous-version-tag>..HEAD`. Derive the tag from the
     previous section's heading link (e.g. `[3.0.4]` links to `v3.0.4`);
     fall back to `git describe --tags --abbrev=0`.
3. Get commit subjects with `git log <range> --pretty=format:'%s'`.
4. Skip merge commits (subjects starting with `Merge`) and duplicate entries.
5. Map each subject to a Keep a Changelog category:
   - `✨ feat` → `### Added`
   - `🐛 fix` → `### Fixed`
   - `💥 breaking` → `### Removed`
   - everything else (`📝 docs`, `💄 style`, `♻️ refactor`, `⚡️ perf`,
     `✅ test`, `👷 build`, `🎡 ci`, `🧹 chore`, unknown) → `### Changed`
6. For each entry, strip the `{emoji} {type}({scope}):` prefix, capitalize
   the result and write it as a bullet `- <description>` with no trailing
   period.
7. Rewrite the entry list of the top section: keep the `## [version]` header
   and any prose before the first `### ` heading; replace everything from the
   first `### ` heading to the end of the section with the generated
   categories (`### Added`, `### Changed`, `### Removed`, `### Fixed` in that
   order, entries sorted alphabetically). If the section has no `### `
   heading, append the generated categories at the end of the section.
8. If there are no commits in the range, report it and do not modify the
   file.

## Restrictions

- Only modify `CHANGELOG.md`. Do not commit or push.
- Do not touch sections below the top section.
- Once ready create a git commit message using `@.opencode/command/git-commit-message.md`.

## Output

List the changes made to `CHANGELOG.md`.
