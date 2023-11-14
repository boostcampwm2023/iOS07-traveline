import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

// MARK: - Project

let project = Project.app(
    name: Project.Environmnet.workspace,
    platform: .iOS,
    additionalTargets: []
)
