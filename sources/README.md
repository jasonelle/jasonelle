# Sources

This directory stores the source projects used by Jasonelle.

## Workflow

1. Download the source files from `https://jasonelle.com`.
2. Configure `config.jsonc`, images and scripts inside the `lib/` directory.
3. Generate the application project with the `/ios` or `/android` command
   inside your LLM service. This will create a `build/` directory.
4. Configure the final generated project inside `build/`, compile and send to
   the App Store (iOS) or Play Store (Android). You can generate the AppIcon
   with `/icon`.

## Layout

- `xcode/`: Xcode projects.
  - `Application/`: The iOS app. Contains the app target, assets
    (`Assets.xcassets`), resources and the `Application.docc` documentation.
  - `Core/`: Shared library consumed by the app. Contains the `Core.docc`
    documentation.
- `.clang-format`: Formatting rules for C/C++/Objective-C sources.
- `.swiftlint.yml`: SwiftLint rules for the Swift sources.

## Documentation

Each Xcode project ships a DocC catalog (`*.docc`) with Markdown files
describing its components. Open the project in Xcode to browse them.

## Notes

There is no `android/` project yet. Only the iOS (Xcode) sources are currently
present.
