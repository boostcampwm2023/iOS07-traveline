//
//  MyPostListViewModel.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/30.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

enum MyPostListAction: BaseAction {
    case viewDidLoad
}

enum MyPostListSideEffect: BaseSideEffect {
    case loadMyPostList(TravelList)
    case loadFailed
}

struct MyPostListState: BaseState {
    var travelList: TravelList = .init()
}

final class MyPostListViewModel: BaseViewModel<MyPostListAction, MyPostListSideEffect, MyPostListState> {
    
    private let myPostListUseCase: MyPostListUseCase
    
    init(myPostListUseCase: MyPostListUseCase) {
        self.myPostListUseCase = myPostListUseCase
    }
    
    override func transform(action: Action) -> SideEffectPublisher {
        switch action {
        case .viewDidLoad:
            return loadMyPostList()
        }
    }
    
    override func reduceState(state: State, effect: SideEffect) -> State {
        var newState = state
        
        switch effect {
        case .loadMyPostList(let list):
            newState.travelList = list
        case .loadFailed:
            break
        }
        
        return newState
    }
}

// MARK: - Functions

extension MyPostListViewModel {
    func loadMyPostList() -> SideEffectPublisher {
        return myPostListUseCase.fetchMyPostList()
            .map { list in
                return MyPostListSideEffect.loadMyPostList(list)
            }
            .catch { _ in
                return Just(MyPostListSideEffect.loadFailed)
            }
            .eraseToAnyPublisher()
    }
}
