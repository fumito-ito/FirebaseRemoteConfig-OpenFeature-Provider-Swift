// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FirebaseRemoteConfigOpenFeatureProvider",
    platforms: [
        .iOS(.v14),
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FirebaseRemoteConfigOpenFeatureProvider",
            targets: ["FirebaseRemoteConfigOpenFeatureProvider"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/open-feature/swift-sdk.git",
            .upToNextMajor(from: "0.3.0")
        ),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .upToNextMajor(from: "10.29.0")
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FirebaseRemoteConfigOpenFeatureProvider",
            dependencies: [
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
                .product(name: "OpenFeature", package: "swift-sdk"),
            ]),
        .testTarget(
            name: "FirebaseRemoteConfigOpenFeatureProviderTests",
            dependencies: ["FirebaseRemoteConfigOpenFeatureProvider"]),
    ]
)
