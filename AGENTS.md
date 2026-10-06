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
- `task icons` (alias `ic`): Generate Android and Xcode app icons using the `tools/icon` binary.
- `task icons.build` (alias `ib`): Generate the `tools/icon` binary.
- `task jsonc.xcode` (alias `jx`): Merge common and Xcode `config.jsonc`/`store.jsonc` into `build/xcode/`.
- `task jsonc.android` (alias `ja`): Merge common and Android `config.jsonc`/`store.jsonc` into `build/android/`.
- `task jsonc` (alias `json`): Runs `task jsonc.xcode` and `task jsonc.android`.
- `task jsonc.build` (alias `jb`): Generate the `tools/jsonc` binary.
- `task bundler` (alias `bn`): Bundle scripts for both Xcode and Android.
- `task bundler.build` (alias `bb`): Build the `tools/bundler` binary.
- `task bundler.xcode` (alias `bx`): Bundle scripts for Xcode only.
- `task bundler.android` (alias `ba`): Bundle scripts for Android only.
- `task bundler.esbuild.install` (alias `bi`): Install the vendored esbuild binary (Unix only).
- `task plugins` (alias `pl`): Copy the plugins listed in the merged configs into `build/<platform>/sources`.
- `task plugins.build` (alias `pb`): Generate the `tools/plugins` binary.
- `task core` (alias `cr`): Assemble the app source tree into `build/<platform>/sources`, overlaying `lib/` overrides.
- `task core.build` (alias `cb`): Generate the `tools/core` binary.
- `task appconf` (alias `aid`): Set the Xcode bundle identifiers/display name and Android `applicationId`/label from the `app_id` and `app_name` in the merged configs.
- `task appconf.build` (alias `aib`): Generate the `tools/appconf` binary.
- `task link` (alias `l`): Link the plugins present in `build/<platform>/sources` into the Xcode workspace and the Android projects.
- `task link.build` (alias `lb`): Generate the `tools/link` binary.
- `task fastlane` (alias `fl`): Generate the Fastlane files from the merged `store.jsonc` into `build/<platform>/fastlane` and copy them into `build/<platform>/sources`.
- `task fastlane.build` (alias `flb`): Generate the `tools/fastlane` binary.
- `task gen`: Run the full build pipeline (icon, jsonc, bundler, plugins, core, link, appconf, fastlane).
- `task gen.build` (alias `gb`): Generate the `tools/gen` binary.

## Directory layout

- `antora/`: Antora docs configuration and content (modules, playbook deps).
- `antora-playbook.yml`: Antora site/content/ui/output configuration.
- `sources/`: Source projects (Android, Xcode).
- `tools/`: Auxiliary tools and scripts.
- `website/`: Main website sources.
- `docs/`: Generated site committed for GitHub Pages. Do not edit by hand.
- `CHANGELOG.md`: Notable changes per version, following Keep a Changelog. Update with `/changelog`.
- `Taskfile.yml`: Task runner config (go-task), alternative to a Makefile.
- `.agents/`: Agent rules. Contains `.agents/rules/` with behavioral guidelines for LLM coding agents (e.g. `adhd.md`, `karpathy.md`, `rebuild-tools.md`, `specs.md`).
- `.github/workflows/`: CI builds and publishes docs, creates SemVer pre-releases, and promotes them to releases.
- `.opencode/commands/`: Custom opencode commands:
  - `/adr`: Create a new Architecture Decision Record (MADR) page.
  - `/changelog`: Update CHANGELOG.md from git commit messages.
  - `/command-create`: Create a new opencode command inside `.opencode/commands`.
  - `/gitmoji`: Generate a conventional commit message with a gitmoji
    from the staged changes.
  - `/grill`: Grill the user relentlessly about a plan, decision, or idea.
  - `/license`: Append a license template as a comment to the first lines of a file or directory.
  - `/rule-create`: Create a new rule inside `.agents/rules`.
  - `/tool-create-go`: Create a new Go tool inside `tools/`.
  - `/todo`: Add a pending task to the `TODO` file in the repository root.
  - `/update-agents`: Update AGENTS.md with the latest project changes.
  - `/version-bump`: Bump the version in a version file to the next version.
  - `/yaml`: Lint and format YAML files with yamllint and prettier.

## Skills

Invoke the matching skill instead of improvising the workflow. Sources:

- `.agents/skills/`: project skills.
- `.opencode/opencode.jsonc` → `plugin[]`: the `superpowers` and `ponytail`
  plugins, whose skills ship with the plugin packages.

<available_skills>
  <skill>
    <name>generate-tests</name>
    <description>Use when the user asks to generate, create, write, or add unit tests for existing code, or to cover a class, method, or file with tests — including Java targets using JUnit 5, Mockito, or AssertJ. Not for analysis-only requests that stop at listing test cases.</description>
  </skill>
  <skill>
    <name>generate-test-cases</name>
    <description>Use when the user asks to analyze code for test coverage, list what test cases are needed, or review testing strategy — WITHOUT generating actual test code.</description>
  </skill>
  <skill>
    <name>using-superpowers</name>
    <description>Load first, before any response or action. Establishes how and when to invoke skills.</description>
  </skill>
  <skill>
    <name>brainstorming</name>
    <description>Use before any creative work — new features, components, or changed behavior. Explores intent and design before implementation.</description>
  </skill>
  <skill>
    <name>writing-plans</name>
    <description>Use when a spec or requirements exist for a multi-step task, before touching code.</description>
  </skill>
  <skill>
    <name>executing-plans</name>
    <description>Use when executing a written implementation plan in a separate session, with review checkpoints.</description>
  </skill>
  <skill>
    <name>subagent-driven-development</name>
    <description>Use when executing an implementation plan whose tasks are independent and can run in this session.</description>
  </skill>
  <skill>
    <name>dispatching-parallel-agents</name>
    <description>Use when facing two or more independent tasks with no shared state or ordering.</description>
  </skill>
  <skill>
    <name>using-git-worktrees</name>
    <description>Use to isolate feature work from the current workspace, or before executing an implementation plan.</description>
  </skill>
  <skill>
    <name>systematic-debugging</name>
    <description>Use on any bug, test failure, or unexpected behavior, before proposing fixes. Find the root cause.</description>
  </skill>
  <skill>
    <name>test-driven-development</name>
    <description>Use when implementing any feature or bugfix, before writing implementation code.</description>
  </skill>
  <skill>
    <name>verification-before-completion</name>
    <description>Use before claiming work is complete, fixed, or passing. Run the command, read the output, then assert.</description>
  </skill>
  <skill>
    <name>requesting-code-review</name>
    <description>Use when completing tasks or before merging, to verify the work meets its requirements.</description>
  </skill>
  <skill>
    <name>receiving-code-review</name>
    <description>Use when acting on review feedback, especially when it is unclear or technically questionable. Verify before implementing.</description>
  </skill>
  <skill>
    <name>finishing-a-development-branch</name>
    <description>Use when implementation is done and all tests pass, to decide how to integrate the work.</description>
  </skill>
  <skill>
    <name>writing-skills</name>
    <description>Use when creating new skills or editing existing ones.</description>
  </skill>
  <skill>
    <name>ponytail</name>
    <description>Use on any coding task to find the laziest solution that actually works. YAGNI, reuse, stdlib, native, fewest files. Switch level with <code>lite|full|ultra</code>.</description>
  </skill>
  <skill>
    <name>ponytail-review</name>
    <description>Code review that only hunts over-engineering: what to delete, what stdlib or native feature replaces it.</description>
  </skill>
  <skill>
    <name>ponytail-audit</name>
    <description>Whole-repo over-engineering audit. One-shot ranked report of what to delete or simplify. Changes nothing.</description>
  </skill>
  <skill>
    <name>ponytail-debt</name>
    <description>Harvest every <code>ponytail:</code> comment into a debt ledger of deliberate shortcuts. One-shot report.</description>
  </skill>
  <skill>
    <name>ponytail-gain</name>
    <description>Show ponytail's measured impact as a scoreboard: less code, less cost, more speed. One-shot display.</description>
  </skill>
  <skill>
    <name>ponytail-help</name>
    <description>Quick-reference card for all ponytail modes, skills, and commands. One-shot display.</description>
  </skill>
</available_skills>

Plugin skills ship with the packages, not this file. Keep their entries
one-liners: the skill's own <code>SKILL.md</code> is the source of truth, so
regenerate this block rather than paraphrasing detail into it.

### Test workflow

Run the two skills in order — do not go straight to `generate-tests`:

1. `generate-test-cases <target>`: its Given-When-Then list is the plan and stays
   visible so the tests can be checked against it.
2. `generate-tests <target>`: generate from **that** list. Do not re-analyse the
   target from scratch; name any case added or dropped, and why.

Stop after step 1 only when the user asked for the analysis alone.

Key principles: INCLUDE each code branch, unique return value, and exception
type. EXCLUDE duplicate scenarios, collection size variations, and speculative
cases. Format: `{method}_{state}_{outcome}` naming. Structure: Given-When-Then
with `actual`/`expected` prefixes.

## Conventions

- YAML: 2-space indentation. Lint with `yamllint` and format with `prettier`
  (see `.opencode/commands/yaml.md`). Line length max 220.
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
- Check for `*.docc` directories inside `sources/xcode/**` for markdown files for iOS components.
