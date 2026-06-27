# Contributing

This repo is set up for an iOS + watchOS SwiftUI app with a small Swift Package target for platform-neutral logic.

## Prerequisites

- Install full Xcode from Apple. Command Line Tools alone are not enough for iOS/watchOS simulator builds or device installs.
- Point `xcode-select` at full Xcode:

```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
xcode-select -p
xcodebuild -version
```

- Sign in with an Apple Developer account in Xcode: `Xcode > Settings > Accounts`.
- For real-device runs, use a paired iPhone and Apple Watch. The iPhone and Watch must be trusted, unlocked when prompted, and available in Xcode's device picker.
- Automatic signing is enabled in the project. Set the development team locally in Xcode before installing on hardware.
- Bluetooth headphones or AirPods are expected for future metronome route testing. Simulator checks cannot prove real Watch audio routing, latency, or Bluetooth behavior.

## Local Checks

These commands assume full Xcode is installed and selected with `xcode-select`. With Command Line Tools only, `swift build` may work, but `swift test` and `xcodebuild` can fail because XCTest, iOS simulators, and watchOS simulators are not available.

Install repo git hooks:

```sh
scripts/install-git-hooks.sh
```

The pre-commit hook checks only staged changes:

- Staged Swift files are linted with SwiftLint.
- `swift test` runs only when staged changes touch `Package.swift`, `Sources/`, or `Tests/`.

Bypass the hook once when needed:

```sh
SKIP_LOCAL_HOOKS=1 git commit ...
```

Run lint if SwiftLint is installed:

```sh
swiftlint --strict
```

Run platform-neutral tests from the package:

```sh
swift test
```

Build the iOS app shell without signing:

```sh
xcodebuild -project RuckABaby.xcodeproj -scheme RuckABaby -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

Build the watchOS app shell without signing:

```sh
xcodebuild -project RuckABaby.xcodeproj -scheme RuckABabyWatchApp -destination 'generic/platform=watchOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

Run on hardware from Xcode after selecting a development team. Do not expect GitHub Actions to install on a real iPhone or Apple Watch.

## Simulator vs Hardware

Good simulator checks:

- App target compilation.
- SwiftUI shell launches.
- Platform-neutral unit tests.
- Basic iOS/watchOS navigation smoke tests once added.

Requires real paired hardware:

- Apple Watch workout behavior.
- Live heart-rate and distance data.
- HealthKit workout save behavior.
- Watch-to-headphones Bluetooth route behavior.
- Metronome audibility, latency, and safety checks.

## Linting and Formatting

SwiftLint runs in CI with `.swiftlint.yml` and should be treated as the current style gate. Install it locally with Homebrew when you want the same check before pushing:

```sh
brew install swiftlint
swiftlint --strict
```

SwiftFormat is intentionally deferred until after the tracer bullet. Formatting automation is useful, but this repo does not yet have enough app code to justify another moving part.

## CI

The `CI` workflow runs on pull requests, direct pushes to `main`, and manual dispatch. It currently:

- Installs SwiftLint.
- Runs `swiftlint --strict`.
- Runs `swift test`.
- Builds the iOS simulator target without signing.
- Builds the watchOS simulator target without signing.

## Non-Goals For Story 0

- No HealthKit workout tracking.
- No real metronome.
- No WatchConnectivity sync.
- No App Store or TestFlight automation.
- No production signing secrets in CI.
