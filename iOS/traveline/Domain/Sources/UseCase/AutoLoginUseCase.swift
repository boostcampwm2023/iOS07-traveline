//
//  AutoLoginUseCase.swift
//  traveline
//
//  Created by 김태현 on 12/7/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

import Core

public protocol AutoLoginUseCase {
    func requestLogin() -> AnyPublisher<Bool, Error>
}

public final class AutoLoginUseCaseImpl: AutoLoginUseCase {

    private let repository: AuthRepository

    public init(repository: AuthRepository) {
        self.repository = repository
    }

    public func requestLogin() -> AnyPublisher<Bool, Error> {
        guard let isFirstEntry = UserDefaultsList.isFirstEntry,
              !isFirstEntry else {
            return Just(false)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        return Future {
            let accessToken = try await self.repository.refresh()
            KeychainList.accessToken = accessToken
            return true
        }.eraseToAnyPublisher()
    }

}
