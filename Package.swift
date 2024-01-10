// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FirebaseRemoteConfig-OpenFeature-Provider-Swift",
    platforms: [
        .iOS(.v14),
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FirebaseRemoteConfig-OpenFeature-Provider-Swift",
            targets: ["FirebaseRemoteConfig-OpenFeature-Provider-Swift"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/open-feature/swift-sdk.git",
            .upToNextMajor(from: "0.0.2")
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FirebaseRemoteConfig-OpenFeature-Provider-Swift"),
        .testTarget(
            name: "FirebaseRemoteConfig-OpenFeature-Provider-SwiftTests",
            dependencies: ["FirebaseRemoteConfig-OpenFeature-Provider-Swift"]),
    ]
)
