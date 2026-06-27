// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "RuckABaby",
    platforms: [
        .iOS(.v26),
        .watchOS(.v26),
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
