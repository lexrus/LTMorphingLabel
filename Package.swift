// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "LTMorphingLabel",
    products: [
        .library(name: "LTMorphingLabel", targets: ["LTMorphingLabel"])
    ],
    targets: [
        .target(
            name: "LTMorphingLabel",
            path: "LTMorphingLabel",
            exclude: "LTMorphingLabel/SwiftUI/MorphingText.swift"
        )
    ]
)
