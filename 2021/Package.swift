// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "2021",
    products: [
        .library(name: "Utilities", targets: ["Utilities"])
    ],
    targets: [
        .target(name: "Utilities"),
        .executableTarget(name: "Day01", dependencies: ["Utilities"])
    ]
)
