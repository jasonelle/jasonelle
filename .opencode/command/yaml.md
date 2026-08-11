---
description: Lint and format YAML files with yamllint and prettier.
---

Lint and format the YAML files in this project.

Run `prettier` to format the files, then `yamllint` to lint them, and fix any issues they report. Confirm the final state passes `yamllint` cleanly.

## Target files

- If the user passed file paths via $ARGUMENTS, use only those.
- Otherwise, lint and format all tracked YAML files (`.yml` and `.yaml`) in the project.

## Restrictions

- Use `prettier --write <file> 2>&1 || npx -y prettier@3.9.6 --write <file>` for prettier actions.
- Use `yamllint <file> 2>&1 || pipx run yamllint <file> 2>&1` for yamllint actions.
