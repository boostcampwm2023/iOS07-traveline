//
//  SettingVeiwModel.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/05.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

enum SettingAction: BaseAction {
    case logoutButtonTapped
    case withdrawalButtonTapped
}

enum SettingSideEffect: BaseSideEffect {
    case logout
    case requestWithdraw
    case error(String)
}

struct SettingState: BaseState {
    
}

final class SettingViewModel: BaseViewModel<SettingAction, SettingSideEffect, SettingState> {
    
    private let useCase: SettingUseCase
    
    init(useCase: SettingUseCase) {
        self.useCase = useCase
    }
    
    override func transform(action: Action) -> SideEffectPublisher {
        switch action {
        case .logoutButtonTapped:
            return reqeustLogout()
            
        case .withdrawalButtonTapped:
            return requestWithdraw()
        }
    }
    
    override func reduceState(state: SettingState, effect: SettingSideEffect) -> SettingState {
        var newState = state
        
        switch effect {
        case .logout:
            break
            
        case .requestWithdraw:
            break
            
        case .error:
            break
        }
        
        return newState
    }
    
}

extension SettingViewModel {
    private func reqeustLogout() -> SideEffectPublisher {
        useCase.logout()
        return .just(.logout)
    }
    
    private func requestWithdraw() -> SideEffectPublisher {
        // TODO: - 회원탈퇴 요청 로직
        return useCase.requestWithdrawal()
            .map { _ in
                return .requestWithdraw
            }
            .catch { _ in
                return Just(.error("failed request withdrawal"))
            }
            .eraseToAnyPublisher()
    }
}
