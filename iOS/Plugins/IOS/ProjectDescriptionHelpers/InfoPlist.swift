//
//  InfoPlist.swift
//  MyPlugin
//
//  Created by KiWoong Hong on 2023/11/14.
//

import ProjectDescription

public extension Project {
    static let infoPlist: [String: Plist.Value] = [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UIMainStoryboardFile": "",
        "UILaunchStoryboardName": "LaunchScreen"
    ]
}
