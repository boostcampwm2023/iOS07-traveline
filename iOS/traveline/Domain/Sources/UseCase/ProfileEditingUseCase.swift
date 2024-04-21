//
//  ProfileEditingUseCase.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/04.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

import Core

public protocol ProfileEditingUseCase {
    func fetchProfile() -> AnyPublisher<Profile, Error>
    func validate(nickname: String) -> AnyPublisher<NicknameValidationState, Error>
    func update(name: String, imageData: Data?) -> AnyPublisher<Profile, Error>
}

public enum NicknameValidationState {
    case unchanged
    case tooShort
    case available
    case duplicated
    case exceededStringLength
}

public final class ProfileEditingUseCaseImpl: ProfileEditingUseCase {
    
    private let repository: UserRepository
    private var profile: Profile = .empty
    
    public init(repository: UserRepository) {
        self.repository = repository
    }
    
    func fetchProfile() -> AnyPublisher<Profile, Error> {
        return Future {
            self.profile = try await self.repository.fetchUserInfo()
            UserDefaultsList.profile = self.profile
            return self.profile
        }.eraseToAnyPublisher()
    }
    
    func validate(nickname: String) -> AnyPublisher<NicknameValidationState, Error> {
        return Future {
            guard self.isTooShort(nickname) == false else { return .tooShort }
            guard self.isValidStringLength(nickname) else { return .exceededStringLength }
            guard self.isChanged(nickname) else { return .unchanged }
            
            let isDuplicated = try await self.repository.checkDuplication(name: nickname)
            return isDuplicated ? .duplicated : .available
        }.eraseToAnyPublisher()
    }
    
    private func isChanged(_ nickname: String) -> Bool {
        return profile.name != nickname
    }
    
    private func isTooShort(_ nickname: String) -> Bool {
        return nickname.count < 2
    }
    private func isValidStringLength(_ nickname: String) -> Bool {
        return nickname.count < 11
    }
    
    func update(name: String, imageData: Data?) -> AnyPublisher<Profile, Error> {
        return Future {
            let profile = try await self.repository.updateUserInfo(name: name, imageData: imageData)
            UserDefaultsList.profile = profile
            return profile
        }.eraseToAnyPublisher()
    }
    
}
