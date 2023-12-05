//
//  SettingVeiwModel.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/05.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum SettingAction: BaseAction {
    case logoutButtonTapped
    case withdrawalButtonTapped
}

enum SettingSideEffect: BaseSideEffect {
    case requestLogout
    case requestWithdraw
}

struct SettingState: BaseState {
    
}

final class SettingViewModel: BaseViewModel<SettingAction, SettingSideEffect, SettingState> {
    
    override func transform(action: Action) -> SideEffectPublisher {
        switch action {
        case .logoutButtonTapped:
            return reqeustLogout()
        case .withdrawalButtonTapped:
            return requestWithdraw()
        }
    }
    
}

extension SettingViewModel {
    private func reqeustLogout() -> SideEffectPublisher {
        // TODO: - 로그아웃 요청 로직
        print("logout!!!")
        return .just(.requestLogout)
    }
    
    private func requestWithdraw() -> SideEffectPublisher {
        // TODO: - 회원탈퇴 요청 로직
        print("탈퇴!!!")
        return .just(.requestWithdraw)
    }
}
