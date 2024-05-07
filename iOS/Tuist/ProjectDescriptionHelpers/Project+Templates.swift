import ProjectDescription
import EnvPlugin
import ConfigPlugin

extension Project {
    public static func project(
        module: Module,
        product: Product,
        schemes: [Scheme] = [],
        dependencies: [TargetDependency] = []
    ) -> Project {
        return Project(
            name: module.name,
            targets: [
                Target(
                    name: module.name,
                    platform: .iOS,
                    product: product,
                    bundleId: Environmnet.bundleName + module.bundleSuffix,
                    deploymentTarget: Environmnet.deploymentTarget,
                    infoPlist: .extendingDefault(with: infoPlist),
                    sources: ["Sources/**"],
                    resources: module.hasResource ? "Resources/**" : nil,
                    entitlements: "../traveline.entitlements",
                    scripts: [.swiftLintShell],
                    dependencies: dependencies,
                    settings: .settings(
                        base: ["DEVELOPMENT_TEAM": "$(DEVELOPMENT_TEAM)"],
                        configurations: XCConfig.project)
                ),
                Target(
                    name: "\(module.name)Tests",
                    platform: .iOS,
                    product: .unitTests,
                    bundleId: "\(Environmnet.bundleName)Tests",
                    deploymentTarget: Environmnet.deploymentTarget,
                    infoPlist: .default,
                    sources: "Tests/**",
                    dependencies: [
                        .target(name: "\(module.name)")
                    ]
                )
            ],
            schemes: schemes
        )
    }
    
    public static func app(
        dependencies: [TargetDependency] = []
    ) -> Project {
        return .project(
            module: .app,
            product: .app,
            dependencies: dependencies
        )
    }

    // MARK: - Private

    public static func framework(
        module: Module,
        dependencies: [TargetDependency] = []
    ) -> Project {
        return .project(
            module: module,
            product: .framework,
            dependencies: dependencies
        )
    }
}


