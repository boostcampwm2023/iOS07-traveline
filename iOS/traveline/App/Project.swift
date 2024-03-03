//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by KiWoong Hong on 3/3/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
    dependencies: [
        Module.feature,
        Module.data
    ].map(\.project)
)
