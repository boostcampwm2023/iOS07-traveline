//
//  AutoLoginUseCase.swift
//  traveline
//
//  Created by 김태현 on 12/7/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

protocol AutoLoginUseCase {
    func requestLogin() -> AnyPublisher<Bool, Error>
}

final class AutoLoginUseCaseImpl: AutoLoginUseCase {
    
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func requestLogin() -> AnyPublisher<Bool, Error> {
        return Future { promise in
            Task {
                do {
                    let accessToken = try await self.repository.refresh()
                    KeychainList.accessToken = accessToken
                    promise(.success(true))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
