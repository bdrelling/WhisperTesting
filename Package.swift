// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "WhisperTesting",
  products: [],
  dependencies: [
    .package(url: "https://github.com/ggerganov/whisper.spm", branch: "master"),
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
    ),
  ]
)
