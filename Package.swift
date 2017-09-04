// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "CommandLineTool",
    targets: [
        Target(name: "FengNiaoKit", dependencies: []),
        Target(name: "Main", dependencies: ["FengNiaoKit"])
    ],
    dependencies: [
        .Package(url: "https://github.com/jatoben/CommandLine", "3.0.0-pre1" ),
        .Package(url: "https://github.com/onevcat/Rainbow", majorVersion: 2)
    ]
    
)
