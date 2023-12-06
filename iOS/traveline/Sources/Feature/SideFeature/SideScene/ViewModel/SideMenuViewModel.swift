//
//  SideMenuViewModel.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/29.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

enum SideMenuAction: BaseAction {
    case viewDidLoad
}

enum SideMenuSideEffect: BaseSideEffect {
    case loadProfile(Profile)
    case error(String)
}

struct SideMenuState: BaseState {
    
    var profile: Profile = .empty
}

final class SideMenuViewModel: BaseViewModel<SideMenuAction, SideMenuSideEffect, SideMenuState> {
    
    private let useCase: SideMenuUseCase
    
    init(useCase: SideMenuUseCase) {
        self.useCase = useCase
        super.init()
    }
    
    override func transform(action: Action) -> SideEffectPublisher {
        switch action {
        case .viewDidLoad:
            return loadProfile()
        }
    }

    override func reduceState(state: State, effect: SideEffect) -> State {
        var newState = state
        
        switch effect {
        case .loadProfile(let profile):
            newState.profile = profile
        case .error:
            break
        }
        
        return newState
    }
}

private extension SideMenuViewModel {
    func loadProfile() -> SideEffectPublisher {
        return useCase.fetchProfile()
            .map { profile in
                return .loadProfile(profile)
            }
            .catch { _ in
                return Just(.error("failed fetch profile"))
            }
            .eraseToAnyPublisher()
    }
}
