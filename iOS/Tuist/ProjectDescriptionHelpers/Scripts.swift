//
//  Scripts.swift
//  ProjectDescriptionHelpers
//
//  Created by 김태현 on 2023/11/14.
//

import ProjectDescription

public extension TargetScript {
    static let swiftLintShell = TargetScript.pre(
        path: .relativeToRoot("Scripts/SwiftLintRunScript.sh"),
        name: "SwiftLintShell"
    )
}
