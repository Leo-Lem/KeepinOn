// swift-tools-version: 5.7

import PackageDescription

// MARK: - (TARGETS)

let service = Target.target(
  name: "AwardsService"
)

let implementation = Target.target(
  name: "AwardsServiceImpl",
  dependencies: [
    .target(name: service.name),
    "KeyValueStorageService",
    "Errors"
  ], resources: [
    .process("res")
  ]
)

let serviceTests = Target.target(
  name: "\(service.name)Tests",
  dependencies: [
    .target(name: service.name),
    "Previews"
  ],
  path: "Tests/\(service.name)Tests"
)

let implementationTests = Target.testTarget(
  name: "\(implementation.name)Tests",
  dependencies: [
    .target(name: implementation.name),
    .target(name: serviceTests.name)
  ]
)

// MARK: - (PRODUCTS)

let library = Product.library(
  name: service.name,
  targets: [service.name, implementation.name]
)

// MARK: - (DEPENDENCIES)

let kvss = Package.Dependency.package(url: "https://github.com/Leo-Lem/KeyValueStorageService", branch: "main"),
    errors = Package.Dependency.package(url: "https://github.com/Leo-Lem/Errors", branch: "main"),
    previews = Package.Dependency.package(url: "https://github.com/Leo-Lem/Previews", branch: "main")

// MARK: - (PACKAGE)

let package = Package(
  name: library.name,
  defaultLocalization: "en",
  platforms: [.iOS(.v13), .macOS(.v10_15)],
  products: [library],
  dependencies: [kvss, errors, previews],
  targets: [service, implementation, serviceTests, implementationTests]
)
