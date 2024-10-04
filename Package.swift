// swift-tools-version: 5.10

/**
 *  ComponentSystem
 *  Copyright (c) Duc Nguyen 2022
 *  Licensed under the MIT license. See LICENSE file.
 */
import PackageDescription

let release = "1.0.0"

let data = try String(contentsOf: URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("LIB_CHECKSUM"))
var frameworks: [String: String] = [:]
for framework in data.components(separatedBy: "\n").filter { !$0.isEmpty } {
    frameworks[framework.components(separatedBy: ":").first!] = frameworks[framework.components(separatedBy: ":").last!]
}

var debug = true ? "-dbg" : ""

func xcframework(_ package: Dictionary<String, String>.Element) -> Target {
    .binaryTarget(
        name: package.key,
        url: "https://github.com/duke6431/binaries/releases/download/\(package.key.lowercased())" + debug + "-\(release)/\(package.key)-\(release).zip",
        checksum: package.value
    )
}

let package = Package(
    name: "ComponentSystem",
    platforms: [
        .iOS(.v13),
        .macCatalyst(.v16),
        .tvOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CSCore",
            targets: ["CSCore", "DesignCore"]
        ),
        .library(
            name: "CSExts",
            targets: ["CSExts", "DesignExts", "DesignCore"]
        ),
        .library(
            name: "CSExternal",
            targets: ["CSExternal", "DesignExternal"]
        ),
        .library(
            name: "CSUIKit",
            targets: ["CSUIKit", "DesignUIKit", "DesignCore", "DesignExts", "DesignExternal"]
        ),
        .library(
            name: "CSCombineUIKit",
            targets: ["CSCombineUIKit", "CSUIKit"]
        ),
        .library(
            name: "CSRxUIKit",
            targets: ["CSRxUIKit", "CSUIKit"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/nvzqz/FileKit.git", .upToNextMajor(from: "6.1.0")),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/kean/Nuke.git", .upToNextMajor(from: "12.4.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.5.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CSCore",
            dependencies: ["DesignCore"]
        ),
        .target(
            name: "CSExts",
            dependencies: [
                .target(name: "CSCore"),
                "DesignExts"
            ]
        ),
        .target(
            name: "CSExternal",
            dependencies: [
                .target(name: "DesignExternal"),
                "FileKit"
            ]
        ),
        .target(
            name: "CSUIKit",
            dependencies: [
                .target(name: "CSCore"),
                .target(name: "CSExts"),
                .target(name: "CSExternal"),
                "DesignUIKit",
                "SnapKit",
                "Nuke",
            ]
        ),
        .target(
            name: "CSCombineUIKit",
            dependencies: [
                .target(name: "CSUIKit"),
            ]
        ),
        .target(
            name: "CSRxUIKit",
            dependencies: [
                .target(name: "CSUIKit"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
            ]
        )
    ] + frameworks.map(xcframework)
)
