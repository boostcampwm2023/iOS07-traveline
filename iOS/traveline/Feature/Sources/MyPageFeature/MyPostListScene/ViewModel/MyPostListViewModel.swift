//
//  MyPostListViewModel.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/30.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

import Core
import DesignSystem
import Domain

public enum MyPostListAction: BaseAction {
    case viewDidLoad
}

public enum MyPostListSideEffect: BaseSideEffect {
    case loadMyPostList(TravelList)
    case loadFailed
}

public struct MyPostListState: BaseState {
    var travelList: TravelList = .init()
    
    public init() { }
}

public final class MyPostListViewModel: BaseViewModel<MyPostListAction, MyPostListSideEffect, MyPostListState> {
    
    private let myPostListUseCase: MyPostListUseCase
    
    public init(myPostListUseCase: MyPostListUseCase) {
        self.myPostListUseCase = myPostListUseCase
    }
    
    public override func transform(action: Action) -> SideEffectPublisher {
        switch action {
        case .viewDidLoad:
            return loadMyPostList()
        }
    }
    
    public override func reduceState(state: State, effect: SideEffect) -> State {
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
