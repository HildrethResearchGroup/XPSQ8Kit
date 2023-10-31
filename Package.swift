// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "XPSQ8Kit",
  platforms: [.macOS("14.0")],
	products: [
		// Products define the executables and libraries produced by a package, and make them visible to other packages.
		.library(
			name: "XPSQ8Kit",
			targets: ["XPSQ8Kit"]),
	],
	dependencies: [
		// Dependencies declare other packages that this package depends on.
		// .package(url: /* package url */, from: "1.0.0"),
	.package(url: "https://github.com/IBM-Swift/BlueSocket.git", from: "1.0.0")
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages which this package depends on.
		.target(
			name: "XPSQ8Kit",
      dependencies: [
        .product(name: "Socket", package: "BlueSocket")
      ]) /*,
		.testTarget(
			name: "XPSQ8KitTests",
			dependencies: ["XPSQ8Kit"]), */
	]
)
