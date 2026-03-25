// swift-tools-version:6.2

// Package.swift
//
// Copyright (c) 2014 - 2018 Apple Inc. and the project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.txt for license information:
// https://github.com/apple/swift-protobuf/blob/main/LICENSE.txt
//

import PackageDescription

#if canImport(Darwin)
let resources: [Resource] = [
    .copy("PrivacyInfo.xcprivacy")
]
#else
let resources = [Resource]()
#endif

let package = Package(
    name: "SwiftProtobuf",
    products: [
        .executable(
            name: "protoc-gen-swift",
            targets: ["protoc-gen-swift"]
        ),
        .library(
            name: "SwiftProtobuf",
            targets: ["SwiftProtobuf"]
        ),
        .library(
            name: "SwiftProtobufPluginLibrary",
            targets: ["SwiftProtobufPluginLibrary"]
        ),
        .plugin(
            name: "SwiftProtobufPlugin",
            targets: ["SwiftProtobufPlugin"]
        ),
    ],
    traits: [
        .trait(
            name: "BinaryDelimitedStreams",
            description:
                "This trait enables the APIs to serializing binary delimited messages with Foundation Input/Output streams."
        ),
        .trait(name: "FieldMaskUtilities", description: "This trait enables APIs for improved FieldMask support."),
        .default(enabledTraits: ["BinaryDelimitedStreams", "FieldMaskUtilities"]),
    ],
    targets: [
        .target(
            name: "SwiftProtobuf",
            exclude: ["CMakeLists.txt"],
            resources: resources,
            swiftSettings: .packageSettings
        ),
        .target(
            name: "SwiftProtobufPluginLibrary",
            dependencies: ["SwiftProtobuf"],
            exclude: ["CMakeLists.txt"],
            resources: resources,
            swiftSettings: .packageSettings
        ),
        .target(
            name: "SwiftProtobufTestHelpers",
            dependencies: ["SwiftProtobuf"],
            swiftSettings: .packageSettings
        ),
        .executableTarget(
            name: "protoc-gen-swift",
            dependencies: ["SwiftProtobufPluginLibrary", "SwiftProtobuf"],
            exclude: ["CMakeLists.txt"],
            swiftSettings: .packageSettings
        ),
        .executableTarget(
            name: "Conformance",
            dependencies: ["SwiftProtobuf"],
            exclude: ["failure_list_swift.txt", "text_format_failure_list_swift.txt"],
            swiftSettings: .packageSettings
        ),
        .plugin(
            name: "SwiftProtobufPlugin",
            capability: .buildTool(),
            dependencies: ["protoc-gen-swift"]
        ),
        .testTarget(
            name: "SwiftProtobufTests",
            dependencies: ["SwiftProtobuf"],
            swiftSettings: .packageSettings
        ),
        .testTarget(
            name: "SwiftProtobufPluginLibraryTests",
            dependencies: ["SwiftProtobufPluginLibrary", "SwiftProtobufTestHelpers"],
            swiftSettings: .packageSettings
        ),
        .testTarget(
            name: "protoc-gen-swiftTests",
            dependencies: ["protoc-gen-swift", "SwiftProtobufTestHelpers"],
            swiftSettings: .packageSettings
        ),
    ],
    swiftLanguageModes: [.v6],
    cxxLanguageStandard: .gnucxx17
)

// Settings for every Swift target in this package, like project-level settings
// in an Xcode project.
extension Array where Element == PackageDescription.SwiftSetting {
    static var packageSettings: Self {
        [
            .enableUpcomingFeature("ExistentialAny")
        ]
    }
}
