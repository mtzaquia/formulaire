// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Formulaire",
    platforms: [.iOS(.v17), .macOS(.v15)],
    products: [
        .library(
            name: "Formulaire",
            targets: ["Formulaire"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax", from: "602.0.0"),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.2.1"),
        .package(url: "https://github.com/pointfreeco/swift-macro-testing", from: "0.6.3")
    ],
    targets: [
        .target(
            name: "Formulaire",
            dependencies: [
                "FormulaireMacros",
                .product(name: "Collections", package: "swift-collections")
            ],
            swiftSettings: [
                .defaultIsolation(MainActor.self),
                .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
                .enableUpcomingFeature("InferIsolatedConformances"),
            ]
        ),
        .macro(
            name: "FormulaireMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
        ),
        .testTarget(
            name: "FormulaireMacrosTests",
            dependencies: [
                "FormulaireMacros",
                .product(name: "MacroTesting", package: "swift-macro-testing")
            ]
        ),
    ]
)
