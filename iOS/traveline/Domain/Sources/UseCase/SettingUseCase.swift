//
//  SettingUseCase.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/03.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

import Core

public protocol SettingUseCase {
    func requestAppleId() -> AppleIDRequest
    func requestWithdrawal(_ request: WithdrawRequest) -> AnyPublisher<Bool, Error>
    func logout()
}

public final class SettingUseCaseImpl: SettingUseCase {
    
    private let repository: AuthRepository
    
    public init(repository: AuthRepository) {
        self.repository = repository
    }
    
    public func logout() {
        repository.logout()
    }
    
    public func requestAppleId() -> AppleIDRequest {
        return repository.requestAppleId()
    }
    
    public func requestWithdrawal(_ request: WithdrawRequest) -> AnyPublisher<Bool, Error> {
        return Future {
            let result = try await self.repository.withdrawal(request)
            KeychainList.allClear()
            return result
        }.eraseToAnyPublisher()
    }
    
}
