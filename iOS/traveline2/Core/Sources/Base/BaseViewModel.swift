//
//  BaseViewModel.swift
//  traveline
//
//  Created by 김영인 on 2023/11/17.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

class BaseViewModel<Action: BaseAction, SideEffect: BaseSideEffect, State: BaseState> {
    
    // MARK: - Types
    
    typealias Action = Action
    typealias SideEffect = SideEffect
    typealias State = State
    typealias SideEffectPublisher = AnyPublisher<SideEffect, Never>
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Binding Properties
    
    private var actions = PassthroughSubject<Action, Never>()
    private var sideEffects = PassthroughSubject<SideEffect, Never>()
    
    private let stateSubject: CurrentValueSubject<State, Never> = .init(.init())
    
    var state: AnyPublisher<State, Never> {
        return stateSubject.eraseToAnyPublisher()
    }
    
    var currentState: State {
        return stateSubject.value
    }
    
    // MARK: - Initializer
    
    init() {
        self.actions
            .flatMap { [weak owner = self] action -> SideEffectPublisher in
                guard let owner else { return Empty().eraseToAnyPublisher() }
                return owner.transform(action: action)
            }
            .receive(on: DispatchQueue.global())
            .sink(receiveValue: { [weak owner = self] sideEffect in
                owner?.sideEffects.send(sideEffect)
            })
            .store(in: &cancellables)
        
        self.sideEffects
            .scan(stateSubject.value, reduceState)
            .receive(on: DispatchQueue.main)
            .assign(to: \.stateSubject.value, on: self)
            .store(in: &cancellables)
    }
    
    func sendAction(_ action: Action) {
        actions.send(action)
    }
    
    func transform(action: Action) -> SideEffectPublisher {
        return Empty().eraseToAnyPublisher()
    }
    
    func reduceState(state: State, effect: SideEffect) -> State {
        return state
    }
}
