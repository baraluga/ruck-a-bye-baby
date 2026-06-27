# Ruck-a-Bye Baby

Watch-first rucking companion for the MVP in [epic #1](https://github.com/baraluga/ruck-a-bye-baby/issues/1). The current repo baseline tracks [Story 0](https://github.com/baraluga/ruck-a-bye-baby/issues/12).

The iPhone app is the configuration surface. The Apple Watch app is the runtime surface. Story 0 only establishes the repo baseline for the next tracer-bullet story; it does not implement HealthKit workout tracking, WatchConnectivity, or the metronome.

## Current Baseline

- iOS deployment target: 26.0
- watchOS deployment target: 26.0
- Xcode project: `RuckABaby.xcodeproj`
- App schemes: `RuckABaby`, `RuckABabyWatchApp`
- Platform-neutral logic package: `RuckCore`
- Starter tests: `Tests/RuckCoreTests`
- CI: SwiftLint, Swift package tests, unsigned iOS simulator build, unsigned watchOS simulator build

## First-Time Setup

See [CONTRIBUTING.md](CONTRIBUTING.md) for Xcode, signing, paired-device, simulator, Bluetooth, and local validation notes.
