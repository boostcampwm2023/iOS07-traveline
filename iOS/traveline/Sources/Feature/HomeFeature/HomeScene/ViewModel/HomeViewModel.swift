//
//  HomeViewModel.swift
//  traveline
//
//  Created by 김영인 on 2023/11/16.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation
import Combine

enum HomeAction: BaseAction {
    case startSearch
    case searching(String)
    case searchDone(String)
    case cancelSearch
}

enum HomeSideEffect: BaseSideEffect {
    case showRecent
    case showRelated(String)
    case showResult(String)
    case showList
}

struct HomeState: BaseState {
    enum HomeViewType {
        case home
        case recent
        case related
        case result
    }
    
    var homeViewType: HomeViewType = .home
    var searchText: String = ""
}

final class HomeViewModel: BaseViewModel<HomeAction, HomeSideEffect, HomeState> {
    
    override func transform(action: Action) -> SideEffectPublisher {
        switch action {
        case .startSearch:
            Just(HomeSideEffect.showRecent).eraseToAnyPublisher()
        case let .searching(text):
            Just(HomeSideEffect.showRelated(text)).eraseToAnyPublisher()
        case let .searchDone(text):
            Just(HomeSideEffect.showResult(text)).eraseToAnyPublisher()
        case .cancelSearch:
            Just(HomeSideEffect.showList).eraseToAnyPublisher()
        }
    }
    
    override func reduceState(state: State, effect: SideEffect) -> State {
        var newState = state
        
        switch effect {
        case .showRecent:
            newState.homeViewType = .recent
        case let .showRelated(text):
            newState.homeViewType = (text.isEmpty) ? .recent : .related
            newState.searchText = text
        case let .showResult(text):
            newState.homeViewType = .result
            newState.searchText = text
        case .showList:
            newState.homeViewType = .home
        }
        
        return newState
    }
}
