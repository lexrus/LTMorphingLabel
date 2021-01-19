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
            url: "https://github.com/lexrus/LTMorphingLabel/releases/download/0.9.3/LTMorphingLabel.xcframework.zip",
            checksum: "28a0ed8b7df12c763d45b7dde2aa41fd843984b79e6fbd3750f2fc1a6c247a13"
        )
    ]
)
