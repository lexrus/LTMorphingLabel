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
            checksum: "352b9e31aa455969c676eb2a546142e7040655d9a26d5277ba2dda00ce534446"
        )
    ]
)
