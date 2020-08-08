// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreAPI",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "CoreAPI", targets: ["CoreAPI"])
    ],
    dependencies: [
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        .package(path: "BuildSettings")
    ],
    targets: [
        .target(name: "CoreAPI", dependencies: ["Alamofire", "BuildSettings"]),
        .testTarget(name: "CoreAPITests",dependencies: ["CoreAPI"])
    ]
)
