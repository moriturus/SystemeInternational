// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SystemeInternational",
    products: [
        .library(
            name: "UnitesDeBaseDuSI",
            targets: ["UnitesDeBaseDuSI"]
        ),
        .library(
            name: "PrefixesDuSI",
            targets: ["PrefixesDuSI"]
        ),
        .library(
            name: "UnitesDeriveesDuSI",
            targets: ["UnitesDeriveesDuSI"]
        ),
        .library(
            name: "UnitesSI",
            targets: ["UnitesSI"]
        ),
        .library(
            name: "UnitesSICompat",
            targets: ["UnitesSICompat"]
        ),
        .library(
            name: "UtiliseesNonSI",
            targets: ["UtiliseesNonSI"]
        ),
        .library(
            name: "UtiliseesNonSICompat",
            targets: ["UtiliseesNonSICompat"]
        ),
        .library(
            name: "SIAccessories",
            targets: ["SIAccessories"]
        ),
        .executable(
            name: "SystemeInternationalBenchmarks",
            targets: ["SystemeInternationalBenchmarks"]
        ),
    ],
    targets: [
        .target(
            name: "UnitesDeBaseDuSI"
        ),
        .target(
            name: "PrefixesDuSI"
        ),
        .target(
            name: "UnitesDeriveesDuSI",
            dependencies: ["UnitesDeBaseDuSI"]
        ),
        .target(
            name: "UnitesSI",
            dependencies: [
                "UnitesDeBaseDuSI",
                "PrefixesDuSI",
                "UnitesDeriveesDuSI",
            ]
        ),
        .target(
            name: "CompatSupport",
            dependencies: [
                "UnitesDeBaseDuSI",
                "UnitesDeriveesDuSI",
            ]
        ),
        .target(
            name: "UnitesSICompat",
            dependencies: [
                "CompatSupport",
                "UnitesSI",
                "UnitesDeBaseDuSI",
                "UnitesDeriveesDuSI",
            ]
        ),
        .target(
            name: "UtiliseesNonSI",
            dependencies: [
                "UnitesSI",
                "UnitesDeBaseDuSI",
                "UnitesDeriveesDuSI",
            ]
        ),
        .target(
            name: "UtiliseesNonSICompat",
            dependencies: [
                "CompatSupport",
                "UtiliseesNonSI",
                "UnitesSICompat",
                "UnitesDeBaseDuSI",
                "UnitesDeriveesDuSI",
            ]
        ),
        .target(
            name: "SIAccessories",
            dependencies: ["UtiliseesNonSI"]
        ),
        .executableTarget(
            name: "SystemeInternationalBenchmarks",
            dependencies: [
                "UnitesDeBaseDuSI",
                "UnitesDeriveesDuSI",
                "UnitesSI",
            ],
            path: "Benchmarks/SystemeInternationalBenchmarks"
        ),
        .testTarget(
            name: "UnitesDeBaseDuSITests",
            dependencies: ["UnitesDeBaseDuSI"]
        ),
        .testTarget(
            name: "PrefixesDuSITests",
            dependencies: ["PrefixesDuSI"]
        ),
        .testTarget(
            name: "UnitesDeriveesDuSITests",
            dependencies: [
                "UnitesDeriveesDuSI",
                "UnitesDeBaseDuSI",
            ]
        ),
        .testTarget(
            name: "UnitesSITests",
            dependencies: ["UnitesSI"]
        ),
        .testTarget(
            name: "UnitesSICompatTests",
            dependencies: ["UnitesSICompat"]
        ),
        .testTarget(
            name: "UtiliseesNonSITests",
            dependencies: ["UtiliseesNonSI"]
        ),
        .testTarget(
            name: "UtiliseesNonSICompatTests",
            dependencies: ["UtiliseesNonSICompat"]
        ),
        .testTarget(
            name: "SIAccessoriesTests",
            dependencies: ["SIAccessories"]
        ),
        .testTarget(
            name: "SystemeInternationalSamplesTests",
            dependencies: ["UtiliseesNonSI"]
        ),
    ]
)
