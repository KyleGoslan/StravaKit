// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StravaKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "StravaKit", targets: ["StravaKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.8.1"))
    ],
    targets: [
        .target(
            name: "StravaKit",
            dependencies: [
                "RxSwift",
                "Alamofire"
            ]
        ),
        .testTarget(
            name: "StravaKitTests",
            dependencies: ["StravaKit"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
