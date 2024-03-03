//
//  UIViewController+.swift
//  traveline
//
//  Created by 김태현 on 1/16/24.
//  Copyright © 2024 traveline. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// 토스트 메세지를 노출합니다.
    /// - Parameters:
    ///   - message: 노출할 메세지
    ///   - type: 토스트 메세지 타입 (실패, 성공)
    ///   - followsUndockedKeyboard: 키보드 위치를 트래킹하려면 true로 설정
    func showToast(message: String, type: TLToastView.ToastType, followsUndockedKeyboard: Bool = false) {
        let toast: TLToastView = .init(type: type, message: message, followsUndockedKeyboard: followsUndockedKeyboard)
        view.keyboardLayoutGuide.followsUndockedKeyboard = followsUndockedKeyboard
        toast.show(in: view)
    }
    
}
