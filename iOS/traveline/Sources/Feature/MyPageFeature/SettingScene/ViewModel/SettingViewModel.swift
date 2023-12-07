//
//  SettingViewModel.swift
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
    case requestWithdraw(Bool)
    case error(String)
}

struct SettingState: BaseState {
    var moveToLogin: Bool = false
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
            newState.moveToLogin = true
            
        case let .requestWithdraw(isSuccess):
            newState.moveToLogin = isSuccess
            
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
        return useCase.requestWithdrawal()
            .map { isSuccess in
                return .requestWithdraw(isSuccess)
            }
            .catch { _ in
                return Just(.error("failed request withdrawal"))
            }
            .eraseToAnyPublisher()
    }
}
