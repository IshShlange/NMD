// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TodoApp",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .executable(
            name: "TodoApp",
            targets: ["TodoApp"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "TodoApp",
            dependencies: [],
            path: "TodoApp",  // Указываем путь к вашей папке с кодом
            sources: ["TodoApp.swift", "Models", "Views"],  // Все исходники
            resources: []
        )
    ]
)
