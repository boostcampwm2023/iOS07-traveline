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
}

struct MyPostListState: BaseState {
    var travelList: TravelList = .init()
}

final class MyPostListViewModel: BaseViewModel<MyPostListAction, MyPostListSideEffect, MyPostListState> {
    
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
        }
        
        return newState
    }
}

// MARK: - Functions

extension MyPostListViewModel {
    func loadMyPostList() -> SideEffectPublisher {
        // TODO: - 여행 리스트 요청 작업
        let list = TravelListSample.make()
        return .just(MyPostListSideEffect.loadMyPostList(list))
    }
}
