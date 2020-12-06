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
        .target(name: "Day01"),
        .target(name: "Day02"),
        .target(name: "Day03"),
        .target(name: "Day04"),
        .target(name: "Day05"),
        .target(name: "Day06", dependencies: ["Utilities"])
    ]
)
