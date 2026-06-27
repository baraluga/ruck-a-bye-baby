// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "RuckABaby",
    platforms: [
        .iOS(.v17),
        .watchOS(.v10),
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
