//
//  Future+.swift
//  traveline
//
//  Created by 김태현 on 12/14/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

extension Future where Failure == Error {
    
    /// async 응답 결과를 Future publisher로 변환합니다.
    /// - Parameter asyncFulfill: 변환할 async 응답
    public convenience init(_ asyncFulfill: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    let result = try await asyncFulfill()
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}

extension Future where Failure == Never {
    
    /// async 응답 결과를 Future publisher로 변환합니다.
    /// - Parameter asyncFulfill: 변환할 async 응답
    public convenience init(_ asyncFulfill: @escaping () async -> Output) {
        self.init { promise in
            Task {
                let result = await asyncFulfill()
                promise(.success(result))
            }
        }
    }
}
