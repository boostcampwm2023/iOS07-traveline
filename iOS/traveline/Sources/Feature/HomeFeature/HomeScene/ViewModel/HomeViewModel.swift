//
//  HomeViewModel.swift
//  traveline
//
//  Created by 김영인 on 2023/11/16.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation
import Combine

final class HomeViewModel: BaseViewModel<HomeAction, HomeSideEffect, HomeState> {
    
    override func transform(action: Action) -> SideEffectPublisher {
        switch action {
        case .startSearch:
                .just(HomeSideEffect.showRecent)
        case let .searching(text):
                .just(HomeSideEffect.showRelated(text))
        case let .searchDone(text):
                .just(HomeSideEffect.showResult(text))
        case .cancelSearch:
                .just(HomeSideEffect.showList)
        case let .startFilter(type):
                .just(HomeSideEffect.showFilter(type))
        case let .addFilter(filterList):
                .just(HomeSideEffect.saveFilter(filterList))
        case .createTravel:
                .just(HomeSideEffect.showTravelWriting)
        }
    }
    
    override func reduceState(state: State, effect: SideEffect) -> State {
        var newState = state
        
        switch effect {
        case .showRecent:
            newState.homeViewType = .recent
            newState.curFilter = nil
            newState.isSearching = true
        case let .showRelated(text):
            newState.homeViewType = (text.isEmpty) ? .recent : .related
            newState.searchText = text
            newState.isSearching = true
        case let .showResult(text):
            newState.homeViewType = .result
            newState.searchText = text
            newState.isSearching = false
            newState.resultFilters = .make()
        case .showList:
            newState.homeViewType = .home
            newState.isSearching = false
        case let .showFilter(type):
            newState.curFilter = (state.homeViewType == .home) ? state.homeFilters[type] : state.resultFilters[type]
        case let .saveFilter(filterList):
            if state.homeViewType == .home {
                filterList.forEach { newState.homeFilters[$0.type] = $0 }
            } else {
                filterList.forEach { newState.resultFilters[$0.type] = $0 }
            }
            newState.curFilter = nil
        case .showTravelWriting:
            newState.moveToTravelWriting = true
        }
        
        return newState
    }
}
