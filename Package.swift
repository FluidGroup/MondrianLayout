// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "MondrianLayout",
  platforms: [.iOS(.v12)],
  products: [
    .library(name: "MondrianLayout", targets: ["MondrianLayout"])
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
