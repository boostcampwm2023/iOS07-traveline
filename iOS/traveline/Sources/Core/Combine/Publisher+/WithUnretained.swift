//
//  WithUnretained.swift
//  traveline
//
//  Created by 김영인 on 2023/11/27.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine

extension Publisher {
    
    /// 클로저 내부 [weak self]를 생략할 수 있도록 (object, output) 튜플을 반환합니다.
    /// - Parameters:
    ///    - object: 클로저 내부에서 캡쳐할 인스턴스
    /// - Returns: (object, output) 튜플
    ///    - object: 내부 [weak object] 및 guard let을 통해 약한 참조
    ///    - output: 현재 방출되는 값
    func withUnretained<T: AnyObject>(_ object: T) -> Publishers.CompactMap<Self, (T, Self.Output)> {
        compactMap { [weak object] output in
            guard let object = object else {
                return nil
            }
            return (object, output)
        }
    }
}
