# Icon Generator

Go tool that generates Android and Xcode app icons from a single `1024x1024`
PNG source image.

## Requirements

- [Go](https://go.dev) 1.26 or newer (only for compilation. `dist/` directory contains binaries).
- [go-task](https://taskfile.dev) (optional, only for the tasks below).

## Usage

From `tools/icon/src`:

```sh
go run . --source <1024x1024.png> --xcode <xcode-root> --android <android-root>
```

Defaults to `--source lib/common/assets/icon/1024x1024.png`. At least one of
`--xcode` or `--android` is required. The tool writes into `<root>/assets/`.

## Output

- Android: `assets/icon/res/mipmap-{mdpi,hdpi,xhdpi,xxhdpi,xxxhdpi}/`
  `ic_launcher.png` and `ic_launcher_round.png`, plus a 512px store icon
  under `assets/icon/store/`.
- Xcode: `assets/AppIcon.appiconset/` with `icon-*.png` files and
  `Contents.json`.

This tool only generates the classic `AppIcon.appiconset` and not the newer
[Icon Composer](https://developer.apple.com/documentation/Xcode/creating-your-app-icon-using-icon-composer)
`.icon` resource. Generating a compatible Icon Composer icon would need future
improvements, but while Apple still supports `AppIcon` it is not mandatory.

## Tasks

From the repository root:

- `task icons` (`i`): generate app icons into `lib/android` and `lib/xcode`
  from `lib/common/assets/icon/1024x1024.png`, using the `tools/icon/dist`
  binary.
- `task icons.build` (`ib`): build the `tools/icon` binary.

From `tools/icon/src`:

- `task build` (`b`): cross-compile binaries into `../dist/` for macOS
  (amd64/arm64), Linux (amd64) and Windows (amd64).
- `task test` (`t`): run the test suite.

## Release binaries

`dist/` contains prebuilt binaries for each platform, named
`icon-<os>-<arch>` (Windows uses `.exe`).

## More Info

- Check `antora/modules/tools/icon.adoc`
