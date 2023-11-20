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
    case searchStart(String)
    case searchDone(String)
}

enum HomeSideEffect: BaseSideEffect {
    case fetchSearchAPI
    case fetchSearchResultAPI
}

struct HomeState: BaseState {
    var value: Int = 0
}

final class HomeViewModel: BaseViewModel<HomeAction, HomeSideEffect, HomeState> {
    
    override func transform(action: Action) -> SideEffectPublisher {
        switch action {
        case .searchStart:
            fetchSearch()
        case .searchDone:
            fetchSearchResult()
        }
    }
    
    override func reduceState(state: State, effect: SideEffect) -> State {
        var newState = state
        
        switch effect {
        case .fetchSearchAPI:
            newState.value += 1
        case .fetchSearchResultAPI:
            newState.value -= 1
        }
        
        return newState
    }
}

private extension HomeViewModel {
    private func fetchSearch() -> SideEffectPublisher {
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                promise(.success(.fetchSearchAPI))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func fetchSearchResult() -> SideEffectPublisher {
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                promise(.success(.fetchSearchResultAPI))
            }
        }
        .eraseToAnyPublisher()
    }
}
