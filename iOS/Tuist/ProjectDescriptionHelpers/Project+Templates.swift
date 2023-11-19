import ProjectDescription
import EnvPlugin
import ConfigPlugin

extension Project {
    public static func app(
        name: String,
        platform: Platform,
        additionalTargets: [String]
    ) -> Project {
        let targets = makeAppTargets(
            name: name,
            platform: platform,
            dependencies: additionalTargets.map { TargetDependency.target(name: $0) }
        )
        return Project(name: name,
                       organizationName: Environmnet.workspace,
                       targets: targets)
    }

    // MARK: - Private

    private static func makeAppTargets(
        name: String,
        platform: Platform,
        dependencies: [TargetDependency]
    ) -> [Target] {
        let platform: Platform = platform

        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "\(Environmnet.bundleName)",
            deploymentTarget: Environmnet.deploymentTarget,
            infoPlist: .extendingDefault(with: infoPlist),
            sources: ["\(name)/Sources/**"],
            resources: ["\(name)/Resources/**"],
            scripts: [.swiftLintShell],
            dependencies: dependencies,
            settings: .settings(
                base: ["DEVELOPMENT_TEAM": "$(DEVELOPMENT_TEAM)"],
                configurations: XCConfig.project
            )
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "\(Environmnet.bundleName)Tests",
            infoPlist: .default,
            sources: ["\(name)/Tests/**"],
            dependencies: [
                .target(name: "\(name)")
        ])
        return [mainTarget, testTarget]
    }
}
