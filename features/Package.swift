// swift-tools-version: 6.0

import PackageDescription

let tca = Target.Dependency.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
let str = Target.Dependency.product(name: "XCStringsToolPlugin", package: "xcstrings-tool-plugin")
let ext = Target.Dependency.product(name: "Extensions", package: "extensions")
let comps = Target.Dependency.product(name: "SwiftUIComponents", package: "library")
let data = Target.Dependency.product(name: "Data", package: "library")

let strings = Target.PluginUsage.plugin(name: "XCStringsToolPlugin", package: "xcstrings-tool-plugin")
let lint = Target.PluginUsage.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")

let libs: [Target] = [
  .target(name: "App", dependencies: [tca, str, comps, "Projects"], plugins: [lint]),
  .target(name: "Projects", dependencies: [tca, str, comps, data, "EditableProject", "EditableItem"], plugins: [lint]),
  .target(name: "EditableProject", dependencies: [tca, comps, data, "EditableItem"], plugins: [lint, strings]),
  .target(name: "EditableItem", dependencies: [tca, comps, data], plugins: [lint]),
]

let package = Package(
  name: "Features",
  defaultLocalization: "en",
  platforms: [.iOS(.v18), .macOS(.v15)],
  products: libs.map { .library(name: $0.name, targets: [$0.name]) },
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.0.0"),
    .package(url: "https://github.com/liamnichols/xcstrings-tool-plugin.git", from: "0.1.0"),
    .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.1.0"),
    .package(path: "../library")
  ],
  targets: libs + [
    .testTarget(name: "FeaturesTest", dependencies: libs.map { .byName(name: $0.name) }, path: "Test", plugins: [lint])
  ]
)
