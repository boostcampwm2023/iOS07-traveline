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
    case startSearch(String)
    case searchDone(String)
    case cancelSearch
}

enum HomeSideEffect: BaseSideEffect {
    case showText(String)
    case showResult(String)
    case showList
}

struct HomeState: BaseState {
    enum SearchViewType {
        case none
        case recent
        case typing
        case result
    }
    
    var isSearching: Bool = false
    var searchViewType: SearchViewType = .none
    var searchText: String = ""
}

final class HomeViewModel: BaseViewModel<HomeAction, HomeSideEffect, HomeState> {
    
    override func transform(action: Action) -> SideEffectPublisher {
        switch action {
        case let .startSearch(text):
            Just(HomeSideEffect.showText(text)).eraseToAnyPublisher()
        case let .searchDone(text):
            Just(HomeSideEffect.showResult(text)).eraseToAnyPublisher()
        case .cancelSearch:
            Just(HomeSideEffect.showList).eraseToAnyPublisher()
        }
    }
    
    override func reduceState(state: State, effect: SideEffect) -> State {
        var newState = state
        
        switch effect {
        case let .showText(text):
            newState.isSearching = true
            newState.searchViewType = text.isEmpty ? .recent : .typing
            newState.searchText = text
        case let .showResult(text):
            newState.isSearching = false
            newState.searchViewType = .result
            newState.searchText = text
        case .showList:
            newState.isSearching = false
            newState.searchViewType = .none
        }
        
        return newState
    }
}
