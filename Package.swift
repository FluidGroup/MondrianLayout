// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "MondrianLayout",
  platforms: [.iOS(.v12)],
  products: [
    .library(name: "MondrianLayout", type: .static, targets: ["MondrianLayout"]),
    .library(name: "MondrianLayout", type: .dynamic, targets: ["MondrianLayout"])
  ],
  dependencies: [],
  targets: [
    .target(
      name: "MondrianLayout",
      dependencies: [],
      path: "MondrianLayout"
    )
  ]
)
