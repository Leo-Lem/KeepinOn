// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "AwardsController",
  defaultLocalization: "en",
  platforms: [.iOS(.v13), .macOS(.v10_15)]
)

// MARK: - (DEPENDENCIES)

let errors = "Errors"
let previews = "Previews"
let concurrency = "Concurrency"
let misc = "LeosMisc"
let colors = "Colors"

for name in [errors, previews, concurrency, misc] {
  package.dependencies.append(.package(url: "https://github.com/Leo-Lem/\(name)", branch: "main"))
}

package.dependencies.append(.package(name: colors, path: "/Users/leolem/dev/apps/portfolio/resources/lib/colors"))

// MARK: - (TARGETS)

let controller = Target.target(
  name: "AwardsController",
  dependencies: [
    .byName(name: previews),
    .byName(name: errors),
    .byName(name: misc),
    .byName(name: concurrency),
    .byName(name: colors)
  ],
  path: "Sources",
  resources: [.process("res")]
)

let tests = Target.testTarget(
  name: "\(controller.name)Tests",
  dependencies: [.target(name: controller.name)],
  path: "Tests"
)

package.targets.append(contentsOf: [controller, tests])

// MARK: - (PRODUCTS)

package.products.append(.library(name: package.name, targets: [controller.name]))
