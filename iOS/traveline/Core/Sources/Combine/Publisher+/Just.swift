//
//  Publisher+.swift
//  traveline
//
//  Created by 김영인 on 2023/11/27.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine

extension Publisher {
    
    /// 단일 값을 방출하는 Publisher를 생성합니다.
    /// - Parameters:
    ///    - data: 방출할 값
    /// - Returns: data 타입의 AnyPublisher
    public static func just<T>(_ data: T) -> AnyPublisher<T, Never> {
        return Just(data).eraseToAnyPublisher()
    }
}
