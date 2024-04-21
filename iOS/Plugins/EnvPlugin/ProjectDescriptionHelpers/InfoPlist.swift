//
//  InfoPlist.swift
//  EnvPlugin
//
//  Created by KiWoong Hong on 2023/11/14.
//

import ProjectDescription

public extension Project {
    static let infoPlist: [String: Plist.Value] = [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UIMainStoryboardFile": "",
        "UILaunchStoryboardName": "LaunchScreen",
        "UIUserInterfaceStyle": "Dark",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ],
                ]
            ]
        ],
        "ITSAppUsesNonExemptEncryption": "false",
        "ProdURL": "$(PROD_URL)",
        "DevURL": "$(DEV_URL)"
    ]
}
