// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NoPressureApp",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "NoPressureApp",
            targets: ["NoPressureApp"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/open-spaced-repetition/swift-fsrs", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "NoPressureApp",
            dependencies: [
                .product(name: "FSRS", package: "swift-fsrs")
            ]
        )
    ]
)
