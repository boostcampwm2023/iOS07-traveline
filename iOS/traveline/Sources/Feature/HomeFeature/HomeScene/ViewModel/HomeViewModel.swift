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
        case .showTravelWriting:
            newState.moveToTravelWriting = true
        }
        
        return newState
    }
}
