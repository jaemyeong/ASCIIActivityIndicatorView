// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "ASCIIActivityIndicatorView",
    defaultLocalization: "ko",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "ASCIIActivityIndicatorView",
            targets: [
                "ASCIIActivityIndicatorView",
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/jaemyeong/Pretendard.git", .upToNextMajor(from: "0.2.1")),
        .package(url: "https://github.com/jaemyeong/OpenColorKit.git", .upToNextMajor(from: "0.1.5")),
        .package(url: "https://github.com/jaemyeong/ErrorKit.git", .upToNextMajor(from: "0.1.7")),
    ],
    targets: [
        .target(
            name: "ASCIIActivityIndicatorView",
            dependencies: [
                "Pretendard",
                "OpenColorKit",
                "ErrorKit",
            ]
        ),
        .testTarget(
            name: "ASCIIActivityIndicatorViewTests",
            dependencies: [
                "ASCIIActivityIndicatorView"
            ]
        ),
    ]
)
