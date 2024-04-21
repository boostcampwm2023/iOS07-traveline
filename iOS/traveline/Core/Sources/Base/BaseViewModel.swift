//
//  BaseViewModel.swift
//  traveline
//
//  Created by 김영인 on 2023/11/17.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

open class BaseViewModel<Action: BaseAction, SideEffect: BaseSideEffect, State: BaseState> {
    
    // MARK: - Types
    
    public typealias Action = Action
    public typealias SideEffect = SideEffect
    public typealias State = State
    public typealias SideEffectPublisher = AnyPublisher<SideEffect, Never>
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Binding Properties
    
    private var actions = PassthroughSubject<Action, Never>()
    private var sideEffects = PassthroughSubject<SideEffect, Never>()
    
    private let stateSubject: CurrentValueSubject<State, Never> = .init(.init())
    
    public var state: AnyPublisher<State, Never> {
        return stateSubject.eraseToAnyPublisher()
    }
    
    public var currentState: State {
        return stateSubject.value
    }
    
    // MARK: - Initializer
    
    public init() {
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
    
    public func sendAction(_ action: Action) {
        actions.send(action)
    }
    
    open func transform(action: Action) -> SideEffectPublisher {
        return Empty().eraseToAnyPublisher()
    }
    
    open func reduceState(state: State, effect: SideEffect) -> State {
        return state
    }
}
