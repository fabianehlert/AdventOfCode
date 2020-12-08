// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "2020",
    products: [
        .library(name: "Utilities", targets: ["Utilities"])
    ],
    targets: [
        .target(name: "Utilities"),
        .target(name: "Day01", dependencies: ["Utilities"]),
        .target(name: "Day02", dependencies: ["Utilities"]),
        .target(name: "Day03", dependencies: ["Utilities"]),
        .target(name: "Day04", dependencies: ["Utilities"]),
        .target(name: "Day05", dependencies: ["Utilities"]),
        .target(name: "Day06", dependencies: ["Utilities"]),
        .target(name: "Day07", dependencies: ["Utilities"]),
        .target(name: "Day08", dependencies: ["Utilities"])
    ]
)
