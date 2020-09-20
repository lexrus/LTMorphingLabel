// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "LTMorphingLabel",
    products: [
        .library(name: "LTMorphingLabel", targets: ["LTMorphingLabel"]),
        .library(name: "LTMorphingLabelXCFramework", targets: ["LTMorphingLabelXCFramework"])
    ],
    targets: [
        .target(
            name: "LTMorphingLabel",
            path: "LTMorphingLabel",
            exclude: ["LTMorphingLabel/SwiftUI/MorphingText.swift"]
        ),
        .target(
            name: "LTMorphingLabelXCFramework",
            url: "https://github.com/lexrus/LTMorphingLabel/releases/download/0.9.1/LTMorphingLabel.framework.zip",
            checksum: "c40d71025beb8be5855cf78c0a4ab8d16762d183adce2b5196cff3d3a3c65c2e"
        )
    ]
)
