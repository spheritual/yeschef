// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "YesChefDemo",
    platforms: [.macOS(.v14)],
    dependencies: [.package(path: "../YesChefCore")],
    targets: [
        .executableTarget(name: "yeschef-demo", dependencies: [.product(name: "YesChefCore", package: "YesChefCore")]),
    ]
)
