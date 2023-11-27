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
    case startFilter(FilterType)
    case addFilter([Filter])
}

enum HomeSideEffect: BaseSideEffect {
    case showRecent
    case showRelated(String)
    case showResult(String)
    case showList
    case showFilter(FilterType)
    case saveFilter([Filter])
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
    var filters: [FilterType: Filter] = FilterType.allCases.reduce(into: [:]) { filters, type in
        filters[type] = .init(type: type, selected: [])
    }
    var curFilter: Filter? = .emtpy
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
        case let .startFilter(type):
            Just(HomeSideEffect.showFilter(type)).eraseToAnyPublisher()
        case let .addFilter(filterList):
            Just(HomeSideEffect.saveFilter(filterList)).eraseToAnyPublisher()
        }
    }
    
    override func reduceState(state: State, effect: SideEffect) -> State {
        var newState = state
        
        switch effect {
        case .showRecent:
            newState.homeViewType = .recent
            newState.curFilter = nil
        case let .showRelated(text):
            newState.homeViewType = (text.isEmpty) ? .recent : .related
            newState.searchText = text
        case let .showResult(text):
            newState.homeViewType = .result
            newState.searchText = text
        case .showList:
            newState.homeViewType = .home
        case let .showFilter(type):
            newState.curFilter = state.filters[type]
        case let .saveFilter(filterList):
            filterList.forEach { newState.filters[$0.type] = $0 }
            newState.curFilter = nil
            print(filterList)
        }
        
        return newState
    }
}
