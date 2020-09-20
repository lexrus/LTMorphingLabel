// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "MorphingLabel",
    products: [
        .library(name: "MorphingLabel", targets: ["MorphingLabel"]),
        .library(name: "MorphingLabelDynamic", type: .dynamic, targets: ["MorphingLabel"]),
        .library(name: "MorphinglabelXCFramework", targets: ["LTMorphingLabel"])
    ],
    targets: [
        .target(
            name: "MorphingLabel",
            path: "LTMorphingLabel",
            exclude: ["SwiftUI"],
            resources: [
                .process("Particles/*.png")
            ]
        ),
        .binaryTarget(
            name: "LTMorphingLabel",
            url: "https://github.com/lexrus/LTMorphingLabel/releases/download/0.9.2/LTMorphingLabel.xcframework.zip",
            checksum: "a3a12be1e08b84b7d9a1dd99806bc524b4515c277794d325155bb6e06ed2584a"
        )
    ]
)
