# AGENTS.md

Guidelines for AI agents working in this repository.

## Project

Jasonelle. It generates docs with Antora (inside a Docker
container) and publishes them to GitHub Pages via a GitHub Actions workflow.

## Commands

- `task default`: Run `task build.docs`.
- `task install` (alias `i`): Build the Antora Docker image (`antora/`).
- `task shell` (alias `sh`): Open a shell inside the Antora container.
- `task build.all` (alias `b`, `build`): Clean `docs/`, build docs and copy the website.
- `task build.docs` (alias `bd`, `docs`): Generate the Antora site into `docs/docs/`.
- `task build.website` (alias `bw`, `web`): `rsync` `website/` into `docs/`.
- `task serve.docs` (alias `sd`): Serve `docs/docs/` on `localhost:8000`.
- `task serve.website` (alias `s`, `sw`): Serve `docs/` on `localhost:8000`.
- `task lint.yaml` (alias `ly`): Format and lint all YAML files with prettier and yamllint.
- `task git.add` (alias `ga`): Add all the changes from the current directory.
- `task git.commit` (aliases `c`, `gc`): Commit staged changes using the message in `.commit-message`.
- `task git.pull` (aliases `pl`, `gpl`): Pull the current branch from origin.
- `task git.push` (aliases `p`, `gp`): Push the current branch to origin.
- `task git.all` (alias `gal`): Push all the current changes to the branch in origin.

## Directory layout

- `antora/`: Antora docs configuration and content (modules, playbook deps).
- `antora-playbook.yml`: Antora site/content/ui/output configuration.
- `sources/`: Source projects (Android, Xcode).
- `tools/`: Auxiliary tools and scripts.
- `website/`: Main website sources.
- `docs/`: Generated site committed for GitHub Pages. Do not edit by hand.
- `CHANGELOG.md`: Notable changes per version, following Keep a Changelog. Update with `/changelog`.
- `Taskfile.yml`: Task runner config (go-task), alternative to a Makefile.
- `.agents/`: Agent rules. Contains `.agents/rules/` with behavioral guidelines for LLM coding agents (e.g. `karpathy.md`).
- `.github/workflows/`: CI builds and publishes docs, creates SemVer pre-releases, and promotes them to releases.
- `.opencode/command/`: Custom opencode commands:
  - `/adr`: Create a new Architecture Decision Record (MADR) page.
  - `/adr-accept`: Update an ADR status to Accepted.
  - `/adr-deprecate`: Update an ADR status to Deprecated.
  - `/adr-supersed`: Update an ADR status to Superseded.
  - `/changelog`: Update CHANGELOG.md from git commit messages.
  - `/git-commit-message`: Generate a conventional commit message with a gitmoji
    from the staged changes.
  - `/update-agents`: Update AGENTS.md with the latest project changes.
  - `/yaml`: Lint and format YAML files with yamllint and prettier.
  - `/yaml-antora`: Lint and format `antora-playbook.yml` and `antora/antora.yml`.
  - `/yaml-github`: Lint and format YAML files inside `.github/`.
  - `/yaml-taskfile`: Lint and format `Taskfile.yml`.

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

## How to find more documentation
- Agent rules: [.agents/rules/](.agents/rules/).
- Use Context7 MCP if available for obtaining additional documentation and context for the task.
