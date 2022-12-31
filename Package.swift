// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "WhisperTesting",
  products: [],
  dependencies: [
    .package(url: "https://github.com/ggerganov/whisper.spm", from: "1.0.0"),
  ],
  targets: [
    .testTarget(
      name: "WhisperTests",
      dependencies: [
        .product(name: "whisper", package: "whisper.spm"),
      ],
      resources: [
        .copy("models"),
      ]
      // Does nothing
      // cSettings: [
      //   .unsafeFlags(["-O3"]),
      // ]
    ),
  ]
)
