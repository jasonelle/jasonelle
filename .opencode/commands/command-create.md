---
description: Create a new opencode command inside .opencode/command.
---

Create a new opencode command file at `.opencode/command/<name>.md`.

## Arguments

`$ARGUMENTS` is the command name and, optionally, a short description. If the
name is missing, ask the user chose to create one or make a command name from the provided description.

## Steps

1. Sanitize the name to lowercase with dashes (e.g. `/command create my-tool`
   creates `my-tool.md`). If the file already exists, stop and tell the user.
2. Create the file with a `description` frontmatter (and optional `agent`/
   `model`) plus a `## Steps` body. Use `$ARGUMENTS` for the user's input in
   the prompt, `$1`, `$2`, ... for positional arguments.
3. If AGENTS.md lists the project commands, add the new command to that list.

## Template

```markdown
---
description: <Short one-sentence description of what the command does.>
---

<Prompt that explains what to do with the user's arguments.>

## Steps

1. <Step 1>
2. <Step 2>

## Output

- <What to print or produce.>
```

Follow the conventions of the existing commands in `.opencode/command/`.

## Output

- Report the created file path and the line added to AGENTS.md (if any).
