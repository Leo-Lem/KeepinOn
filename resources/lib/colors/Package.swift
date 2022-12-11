// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Colors",
  defaultLocalization: "en",
  platforms: [.iOS(.v13), .macOS(.v10_15)]
)

// MARK: - (DEPENDENCIES)

let mine = (previews: "Previews", misc: "LeosMisc")

for name in [mine.previews, mine.misc] {
  package.dependencies.append(.package(url: "https://github.com/Leo-Lem/\(name)", branch: "main"))
}

// MARK: - (TARGETS)

let colors = Target.target(
  name: "Colors",
  dependencies: [
    .product(name: mine.previews, package: mine.previews),
    .product(name: mine.misc, package: mine.misc)
  ],
  path: "Sources",
  resources: [.process("res")]
)

let tests = Target.testTarget(
  name: "\(colors.name)Tests",
  dependencies: [.target(name: colors.name)],
  path: "Tests"
)

package.targets.append(contentsOf: [colors, tests])

// MARK: - (PRODUCTS)

package.products.append(.library(name: package.name, targets: [colors.name]))
