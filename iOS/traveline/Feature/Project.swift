//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by KiWoong Hong on 3/3/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    module: .feature,
    dependencies: [
        Module.domain,
        Module.designSystem
    ].map(\.project)
)
