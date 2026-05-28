// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "seon_sdk_flutter_plugin",
    platforms: [
        .iOS("15.0"),
    ],
    products: [
        .library(name: "seon-sdk-flutter-plugin", targets: ["seon_sdk_flutter_plugin"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(
            url: "https://github.com/seontechnologies/seon-ios-sdk-swift-package",
            exact: "5.6.3"
        ),
    ],
    targets: [
        .target(
            name: "seon_sdk_flutter_plugin",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "SeonSDK", package: "seon-ios-sdk-swift-package"),
            ],
            resources: [
            ]
        )
    ]
)