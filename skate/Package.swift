// swift-tools-version: 6.2

import PackageDescription

let strictSettings: [SwiftSetting] = [
    .enableExperimentalFeature("StrictMemorySafety"),
    .unsafeFlags(["-warnings-as-errors"]),
]

let package = Package(
    name: "Skate",
    products: [
        .library(name: "SkateCore", targets: ["SkateCore"]),
    ],
    targets: [
        .target(
            name: "SkateCore",
            swiftSettings: strictSettings
        ),
        .testTarget(
            name: "SkateCoreTests",
            dependencies: ["SkateCore"],
            swiftSettings: strictSettings
        ),
    ],
    swiftLanguageModes: [.v6]
)
