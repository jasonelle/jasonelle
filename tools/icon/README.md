# Icon Generator

Go tool that generates Android and Xcode app icons from a single `1024x1024`
PNG source image.

## Usage

From `tools/icon/src`:

```sh
go run src/ --source <1024x1024.png> --out <output-dir>
```

Defaults to `--source lib/common/assets/icon/1024x1024.png` and `--out lib`.

## Output

- Android: `assets/android/res/mipmap-{mdpi,hdpi,xhdpi,xxhdpi,xxxhdpi}/`
  `ic_launcher.png` and `ic_launcher_round.png`, plus a 512px store icon.
- Xcode: `assets/xcode/AppIcon.appiconset/` with `icon-*.png` files and
  `Contents.json`.

## Tasks

Run with [go-task](https://taskfile.dev) from `tools/icon/src`:

- `task icons` (`i`): generate icons using the default source and output.
- `task dist` (`d`): cross-compile binaries into `../dist/` for macOS
  (amd64/arm64), Linux (amd64) and Windows (amd64).
- `task test` (`t`): run the test suite.

## Release binaries

`dist/` contains prebuilt binaries for each platform, named
`icon-<os>-<arch>` (Windows uses `.exe`).
