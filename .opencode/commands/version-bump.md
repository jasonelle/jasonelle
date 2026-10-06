---
description: Bump the version in a version file to the next version.
---

Bump the version in the given file to the next version.

## Arguments

`$1` is the version file path. `$2` is the segment to bump: `major`, `minor`
or `patch`. If `$2` is omitted, bump `patch` (or `minor` for `X.Y` files,
which have no patch segment).

## Steps

1. Read `$1` and find the version value. Look for a `version:` key in YAML
   files (e.g. `antora/antora.yml`); fall back to the first `X.Y`/`X.Y.Z`
   pattern found in the file.
2. Determine the format and bump per `$2`:
   - `X.Y` (e.g. `VERSION` is `4.0`): `major` increments X and resets Y to 0;
     `minor` increments Y. `patch` is not valid — report it and stop.
   - `X.Y.Z` (e.g. `tools/icon/src/VERSION` is `1.0.0`): `major` increments X
     and resets Y and Z to 0; `minor` increments Y and resets Z to 0; `patch`
     increments Z.
3. If `$2` is not `major`, `minor` or `patch`, report the valid values and
   stop.
4. Write the new version back into the file, preserving the original format
   and any surrounding content.
5. Do not commit or push.

## VERSION file list

If no `$1` is given provide the user with a list of known `VERSION` files
and make them choose one to bump.

- `VERSION`: Version of the whole project (format `X.Y`).
- `tools/icon/src/VERSION`: Version of the icon tool (format `X.Y.Z`).

## Output

- Report the file path, the old version and the new version.
