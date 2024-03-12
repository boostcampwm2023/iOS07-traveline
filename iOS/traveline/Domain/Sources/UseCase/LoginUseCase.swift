//
//  LoginUseCase.swift
//  traveline
//
//  Created by 김태현 on 12/7/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

import Core

protocol LoginUseCase {
    func requestLogin(with info: AppleLoginRequest) -> AnyPublisher<Bool, Error>
}

final class LoginUseCaseImpl: LoginUseCase {
    
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func requestLogin(with info: AppleLoginRequest) -> AnyPublisher<Bool, Error> {
        return Future {
            UserDefaultsList.profile = nil
            let tlToken = try await self.repository.appleLogin(with: info)
            KeychainList.accessToken = tlToken.accessToken
            KeychainList.refreshToken = tlToken.refreshToken
            UserDefaultsList.isFirstEntry = false
            return true
        }.eraseToAnyPublisher()
    }
    
}
