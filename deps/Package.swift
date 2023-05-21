// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "KeepinOnDependencies",
  platforms: [.iOS(.v16)]
)

// MARK: - (TARGETS)

let source = Target.target(
  name: package.name,
  path: "Source"
)

let test = Target.testTarget(
  name: "\(source.name)Tests",
  dependencies: [.target(name: source.name)],
  path: "Test"
)

package.targets = [source, test]

// MARK: - (PRODUCTS)

package.products.append(.library(name: package.name, targets: [source.name]))
