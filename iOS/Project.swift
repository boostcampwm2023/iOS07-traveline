import ProjectDescription
import ProjectDescriptionHelpers
import EnvPlugin

// MARK: - Project

let project = Project.app(
    name: Project.Environmnet.workspace,
    platform: .iOS,
    additionalTargets: []
)
