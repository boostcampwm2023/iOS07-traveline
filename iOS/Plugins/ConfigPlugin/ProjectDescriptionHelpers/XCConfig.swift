//
//  XCConfig.swift
//  ConfigPlugin
//
//  Created by 김영인 on 2023/11/16.
//

import ProjectDescription

public enum XCConfig {
    public enum Path {
        static func project() -> ProjectDescription.Path {
            .relativeToRoot("XCConfig/Config.xcconfig")
        }
    }
    
    public static let project: [Configuration] = [
        .debug(name: "DEBUG", xcconfig: Path.project()),
        .release(name: "RELEASE", xcconfig: Path.project())
    ]
}
