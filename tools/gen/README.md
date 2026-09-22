# gen

Runs the Jasonelle build pipeline in one command: `icon`, `jsonc`, `bundler`,
`plugins`, `core`, `link`, `appconf`. Equivalent to the corresponding tasks in the
root `Taskfile.yml`, but without needing the `task` command installed.

Each run resets `build/` (removing it and recreating
`build/<platform>/{config,scripts,sources}` for xcode and android) so steps
always start from a clean, complete directory tree.

## Usage

From the repository root:

```
./tools/gen/dist/gen-<os>-<arch>[.exe]
```

The tool picks its own platform's binary from `tools/<name>/dist/`, so each
step's binary must be built first:

```
cd tools/<name>/src && task build
```

Run a subset of steps:

```
./tools/gen/dist/gen-$(go env GOOS)-$(go env GOARCH) --steps jsonc,bundler
```

Validate: `cd src && task test`. Build: `cd src && task build`.