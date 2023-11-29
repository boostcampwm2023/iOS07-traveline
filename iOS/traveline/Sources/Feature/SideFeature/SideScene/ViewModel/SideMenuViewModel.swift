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
    case loadProfile
}

struct SideMenuState: BaseState {
    var profile: Profile = .init(
        id: "",
        imageURL: "",
        name: ""
    )
}

final class SideMenuViewModel: BaseViewModel<SideMenuAction, SideMenuSideEffect, SideMenuState> {
    
    override func transform(action: Action) -> SideEffectPublisher {
        switch action {
        case .viewDidLoad:
            return .just(.loadProfile)
        }
    }

    override func reduceState(state: State, effect: SideEffect) -> State {
        var newState = state
        
        switch effect {
        case .loadProfile:
            newState.profile = loadProfile()
        }
        
        return newState
    }
}

private extension SideMenuViewModel {
    func loadProfile() -> Profile {
        // TODO: - 프로필을 로드하는 로직. 추후 변경
        return Profile(
            id: "1234",
            imageURL: "https://avatars.githubusercontent.com/u/91725382?s=400&u=29b8023a56a09685aaab53d4eb0dd556254cd902&v=4",
            name: "hongki")
    }
}
