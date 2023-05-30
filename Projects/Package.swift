// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "Projects",
  platforms: [.iOS(.v13)]
)

// MARK: - (DEPENDENCIES)

package.dependencies = [
  .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.53.2")
]

// MARK: - (TARGETS)

let src = Target.target(
  name: package.name,
  dependencies: [
    .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
  ],
  path: "src"
)

let test = Target.testTarget(
  name: "\(src.name)Tests",
  dependencies: [.target(name: src.name)],
  path: "test"
)

package.targets = [src, test]

// MARK: - (PRODUCTS)

package.products = [.library(name: package.name, targets: [src.name])]
