// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreAPI",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "CoreAPI", targets: ["CoreAPI"])
    ],
    dependencies: [
        .package(name: "Alamofire", url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        .package(name: "SDWebImage", url: "https://github.com/SDWebImage/SDWebImage", from: "5.0.0")
    ],
    targets: [
        .target(name: "CoreAPI", dependencies: ["Alamofire", "SDWebImage"]),
        .testTarget(name: "CoreAPITests",dependencies: ["CoreAPI"])
    ]
)
