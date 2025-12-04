// swift-tools-version: 6.0
import PackageDescription

let dependencies: [Target.Dependency] = [
  .product(name: "Algorithms", package: "swift-algorithms"),
  .product(name: "Collections", package: "swift-collections"),
  .product(name: "ArgumentParser", package: "swift-argument-parser"),
]

let package = Package(
  name: "AdventOfCode",
  platforms: [.macOS(.v13), .iOS(.v16), .watchOS(.v9), .tvOS(.v16)],
  dependencies: [
    .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.1"),
    .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.4"),
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
    .package(url: "https://github.com/swiftlang/swift-format.git", from: "602.0.0"),
  ],
  targets: [
    .target(
      name: "Core",
      dependencies: dependencies,
      resources: [.copy("../Data")]
    ),
    .testTarget(
      name: "CoreTests",
      dependencies: ["Core"] + dependencies
    ),
    .executableTarget(
      name: "AdventOfCode",
      dependencies: ["Core"] + dependencies,
      path: "Sources",
      exclude: ["Core"]
    ),
    .testTarget(
      name: "AdventOfCodeTests",
      dependencies: ["AdventOfCode"] + dependencies,
      path: "Tests",
      exclude: ["CoreTests"]
    )
  ],
  swiftLanguageModes: [.v6]
)
