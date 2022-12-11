// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Awards",
  defaultLocalization: "en",
  platforms: [.iOS(.v13), .macOS(.v10_15)]
)

// MARK: - (DEPENDENCIES)

let iap = "InAppPurchaseService"
let errors = "Errors"
let previews = "Previews"
let concurrency = "Concurrency"
let misc = "LeosMisc"
let colors = "Colors"

for name in [iap, errors, previews, concurrency, misc] {
  package.dependencies.append(.package(url: "https://github.com/Leo-Lem/\(name)", branch: "main"))
}

package.dependencies.append(.package(name: colors, path: "/Users/leolem/dev/apps/portfolio/resources/lib/colors"))

// MARK: - (TARGETS)

let service = Target.target(
  name: "AwardsService",
  dependencies: [
    .byName(name: previews),
    .byName(name: errors),
    .byName(name: misc),
    .byName(name: concurrency),
    .byName(name: colors)
  ],
  resources: [.process("res")]
)

let ui = Target.target(
  name: "AwardsUI",
  dependencies: [
    .target(name: service.name),
    .byName(name: iap),
    .byName(name: concurrency),
    .byName(name: misc),
    .byName(name: colors)
  ],
  resources: [.process("res")]
)

let tests = Target.testTarget(
  name: "\(service.name)Tests",
  dependencies: [.target(name: service.name)],
  path: "Tests"
)

package.targets.append(contentsOf: [service, ui, tests])

// MARK: - (PRODUCTS)

package.products.append(.library(name: package.name, targets: [service.name, ui.name]))
