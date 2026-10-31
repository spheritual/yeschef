// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "YesChefCore",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "YesChefCore", targets: ["YesChefCore"]),
    ],
    targets: [
        .target(name: "YesChefCore"),
        .testTarget(name: "YesChefCoreTests", dependencies: ["YesChefCore"]),
    ]
)
