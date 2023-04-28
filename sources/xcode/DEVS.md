# Developer Docs

These docs are for _Jasonelle's Core_ developers or anyone who would like to contribute to the codebase.

## Git Branches

- `main`: Bleeding edge branch, may crash. The branch used for development. Can often be used for testing out new features and bug fixes.

- `stable`: The branch used for battle tested code. Production ready. Normally only commited when doing a new release.

- `template/<name>`: Used as an example for others to follow. Normally when using dependencies that would alter the default structure of the project. For example using _Cocoapods_ or any other configuration that is not for suited for the core releases.

## Git Tags

Normally follows the convention `vx.x.x` (e.g. `v3.0.1`). Would need to tag only for the `stable` branch when doing a release.

- Tries to follow [Semantic Versioning](https://semver.org/) when possible.

## Release Schedule

There is no release schedule defined. Normally after a couple of months
of features and bug fixes the team can decide a new release should be made.

### Release Workflow

- Prepare release (update docs, changelogs and other settings or before release tasks). Ensure that all the extensions are disabled by default on release build.
- Commit and push to `main`.
- Make _Merge (Pull) Request_ from `main` to `stable` (Squash commits).
- Create a new release tag (from `stable` branch) in _Github_.
- Update to next version in `main` and commit and push changes.
- Make an announcement.
