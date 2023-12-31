//
//  SettingUseCase.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/03.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

protocol SettingUseCase {
    func requestAppleId() -> AppleIDRequest
    func requestWithdrawal(_ request: WithdrawRequest) -> AnyPublisher<Bool, Error>
    func logout()
}

final class SettingUseCaseImpl: SettingUseCase {
    
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func logout() {
        repository.logout()
    }
    
    func requestAppleId() -> AppleIDRequest {
        return repository.requestAppleId()
    }
    
    func requestWithdrawal(_ reqeust: WithdrawRequest) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            Task {
                do {
                    let result = try await self.repository.withdrawal(reqeust)
                    KeychainList.allClear()
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
}
