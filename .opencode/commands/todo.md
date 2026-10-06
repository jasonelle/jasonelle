---
description: Add a pending task to the TODO file in the repository root.
---

Add a new pending task to the `TODO` file at the repository root.

## Arguments

`$ARGUMENTS` is the task description.

## Steps

1. Read the root `TODO` file (gitignored, so it never gets committed). If it
   does not exist, create it with a `# TODO` title and a short intro line.
2. Append the task as a bullet `- [ ] $ARGUMENTS` at the end of the task list.
   If an equivalent task already exists, stop and tell the user instead of
   duplicating it. Improve the wording and complement the context given for the task.
3. If the task is already tracked, update it to reflect the new `$ARGUMENTS`
   instead of adding a second bullet.

## Output

- Report the updated `TODO` file path and the added line. Do not commit.
