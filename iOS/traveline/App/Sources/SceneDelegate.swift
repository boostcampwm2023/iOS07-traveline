//
//  SceneDelegate.swift
//  traveline
//
//  Created by 김영인 on 2023/11/15.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

import DesignSystem

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
            
        window = UIWindow(windowScene: windowScene)
        let autoLoginVC = VCFactory.makeAutoLoginVC()
        window?.rootViewController = autoLoginVC
        window?.tintColor = TLColor.main
        window?.makeKeyAndVisible()
    }

}

extension SceneDelegate {
    
    /// 로그인 화면으로 이동, ViewController 스택 초기화
    func changeRootViewControllerToLogin() {
        guard let window = self.window else { return }
        window.rootViewController = VCFactory.makeLoginVC()
        
        UIView.transition(
            with: window,
            duration: 0.2,
            options: [.transitionCrossDissolve],
            animations: nil
        )
    }
    
}
