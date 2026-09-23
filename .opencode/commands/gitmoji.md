---
description: Generate a conventional commit message with a gitmoji from the staged changes.
---

Generate a commit message for the current staged changes.
Additionally look for context inside user provided message: $ARGUMENTS

## Steps

1. Run `git status --short` and `git diff --staged` to inspect the staged changes, and read additional context: $ARGUMENTS.
2. Choose a single gitmoji + conventional commit type that best fits the changes:
   - `✨ feat` new feature
   - `🐛 fix` bug fix
   - `📝 docs` documentation
   - `💄 style` formatting, UI, no code change
   - `♻️ refactor` code change with no behavior change
   - `⚡️ perf` performance improvement
   - `✅ test` add/update tests
   - `👷 build` build system
   - `🎡 ci` CI config
   - `🧹 chore` general cleanup/tasks
   - `⏪ revert` revert a change
   - `💥 breaking` breaking change (use with feat/fix)
3. Write the message in the format `{emoji} {type}({scope}): {description}` (scope optional and lowercase, e.g. `✨ feat(website): add dark mode`).
4. Use the imperative mood, no trailing period, keep the subject under 72 characters. Add a body with more context only if needed; wrap at 72 chars.
5. Write the resulting commit message to a `.commit-message` file.

## Output

- Print ONLY the resulting commit message, nothing else.
- Never run `git commit`, `git add`, or modify any files other than `.commit-message` — print the message and stop.
- If there are no staged changes, say so and do not generate a message.
