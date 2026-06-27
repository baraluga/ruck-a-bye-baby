// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "RuckABaby",
    platforms: [
        .iOS("26.0"),
        .watchOS("26.0"),
        .macOS(.v14)
    ],
    products: [
        .library(name: "RuckCore", targets: ["RuckCore"])
    ],
    targets: [
        .target(name: "RuckCore"),
        .testTarget(name: "RuckCoreTests", dependencies: ["RuckCore"])
    ]
)
