# AGENTS.md

Guidelines for AI agents working in this repository.

## Project

Jasonelle. It generates docs with Antora (inside a Docker
container) and publishes them to GitHub Pages via a GitHub Actions workflow.

## Commands

- `task install` (alias `i`): Build the Antora Docker image (`antora/`).
- `task build.all` (alias `b`, `build`): Clean `docs/`, build docs and copy the website.
- `task build.docs` (alias `bd`, `docs`): Generate the Antora site into `docs/docs/`.
- `task build.website` (alias `bw`, `web`): `rsync` `website/` into `docs/`.
- `task serve.docs` (alias `sd`): Serve `docs/docs/` on `localhost:8000`.
- `task serve.website` (alias `s`, `sw`): Serve `docs/` on `localhost:8000`.
- `task shell` (alias `sh`): Open a shell inside the Antora container.
- `task lint.yaml` (alias `ly`): Format and lint all YAML files with prettier and yamllint.
- `task commit` (alias `c`): Commit staged changes using the message in `.commit-message`.

## Directory layout

- `antora/`: Antora docs configuration and content (modules, playbook deps).
- `antora-playbook.yml`: Antora site/content/ui/output configuration.
- `website/`: Main website sources.
- `docs/`: Generated site committed for GitHub Pages. Do not edit by hand.
- `Taskfile.yml`: Task runner config (go-task), alternative to a Makefile.
- `.github/workflows/`: CI builds docs and commits the result on `main`.
- `.opencode/command/`: Custom opencode commands (e.g., YAML lint/format and commit message helpers).

## Conventions

- YAML: 2-space indentation. Lint with `yamllint` and format with `prettier`
  (see `.opencode/command/yaml.md`). Line length max 220.
- Markdown/AsciiDoc: trailing whitespace is allowed (see `.editorconfig`).
- End of line: LF. UTF-8. Final newline required.

## Build notes

- Antora needs a git repository with commits to render.
- The `docs/` output is committed automatically by CI; regenerating it locally
  is not needed for pull requests that only change source content.
- Antora JS dependencies are vendored in `antora/yarn.tar.gz` to avoid rot;
  update only with the process described in `antora/Dockerfile`.
