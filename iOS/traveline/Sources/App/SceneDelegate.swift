//
//  SceneDelegate.swift
//  OnbanApp
//
//  Created by 박동재 on 2023/10/16.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
            
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
    }

}

