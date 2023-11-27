//
//  SceneDelegate.swift
//  traveline
//
//  Created by 김영인 on 2023/11/15.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
            
        window = UIWindow(windowScene: windowScene)
        let rootContainerVC = RootContainerVC()
        window?.rootViewController = rootContainerVC
        window?.tintColor = TLColor.main
        window?.makeKeyAndVisible()
    }

}
