import ProjectDescription
import ProjectDescriptionHelpers
import EnvPlugin

// MARK: - Project

let workspace = Workspace(
    name: "traveline",
    projects: Module.allCases.map(\.path)
)

