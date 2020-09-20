// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "MorphingLabel",
    products: [
        .library(name: "MorphingLabel", targets: ["MorphingLabel"]),
        .library(name: "MorphingLabel.xcframework", targets: ["MorphingLabel.xcframework"])
    ],
    targets: [
        .target(
            name: "MorphingLabel",
            path: "LTMorphingLabel",
            exclude: ["SwiftUI/MorphingText.swift"],
            resources: [
                .process("Particles/*.png")
            ]
        ),
        .binaryTarget(
            name: "MorphingLabel.xcframework",
            url: "https://github.com/lexrus/LTMorphingLabel/releases/download/0.9.1/MorphingLabel.xcframework.zip",
            checksum: "04cdc84ff3245c4c5fe3c6abf2b3ad9ec27e5b3a992650716b924c819620c472"
        )
    ]
)
