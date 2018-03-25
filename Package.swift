// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IBDecodable",
    products: [
        .library(name: "IBDecodable", targets: ["IBDecodable"])
    ],
    dependencies: [
        .package(url: "https://github.com/drmohundro/SWXMLHash.git", from: "4.0.0")
    ],
    targets: [
        .target(name: "IBDecodable", dependencies: ["SWXMLHash"], path: "Sources")
    ]
)
