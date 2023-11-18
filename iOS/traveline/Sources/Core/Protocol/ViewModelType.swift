//
//  ViewModelType.swift
//  traveline
//
//  Created by 김영인 on 2023/11/18.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine

protocol BaseState {
    init()
}

protocol ViewModelType {
    associatedtype Action
    associatedtype SideEffect
    associatedtype State: BaseState
    
    typealias SideEffectPublisher = AnyPublisher<SideEffect, Never>
}
