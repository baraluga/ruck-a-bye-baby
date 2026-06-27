# Ruck-a-Bye Baby

Watch-first rucking companion for the MVP in [epic #1](https://github.com/baraluga/ruck-a-bye-baby/issues/1).

The iPhone app remains the future configuration surface. The Apple Watch app is the runtime surface and currently carries the fake-HR metronome tracer bullet. HealthKit workout tracking, WatchConnectivity, and iPhone settings remain deferred.

## Current Baseline

- iOS deployment target: 26.0
- watchOS deployment target: 26.0
- Xcode project: `RuckABaby.xcodeproj`
- App schemes: `RuckABaby`, `RuckABabyWatchApp`
- Platform-neutral logic package: `RuckCore`
- Cadence control tests: `Tests/RuckCoreTests`
- CI: SwiftLint, Swift package tests, unsigned iOS simulator build, unsigned watchOS simulator build

## Watch Tracer Bullet

The Watch app has a fake-HR audio metronome tracer bullet: press Start, use Zone 1 / Zone 2 / Zone 3 to simulate effort, and watch the target cadence move by the configured bump while the visual pulse and short audio tick run at the active SPM.

Simulator audio can be unreliable depending on the selected runtime and host audio route. Treat simulator runs as a visual pulse and basic launch check unless you can actually hear the tick. Real Apple Watch audibility, routing, latency, and Bluetooth behavior are not validated yet.

## First-Time Setup

See [CONTRIBUTING.md](CONTRIBUTING.md) for Xcode, signing, paired-device, simulator, Bluetooth, and local validation notes.
