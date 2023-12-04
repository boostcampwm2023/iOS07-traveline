//
//  ProfileEditingUseCase.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/04.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

protocol ProfileEditingUseCase {
    func fetchProfile() -> AnyPublisher<Profile, Error>
    func validate(nickname: String) -> AnyPublisher<NicknameValidationState, Never>
    func update(_ profile: Profile) -> AnyPublisher<Profile, Error>
}

enum NicknameValidationState {
    case unchanged
    case available
    case duplicated
    case exceededStringLength
}

final class ProfileEditingUseCaseImpl: ProfileEditingUseCase {
    
    private let repository: UserRepository
    private var profile: Profile = .empty
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func fetchProfile() -> AnyPublisher<Profile, Error> {
        return Future { promise in
            Task { [weak self] in
                guard let self else { return }
                do {
                    profile = try await self.repository.fetchUserInfo()
                    promise(.success(profile))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func validate(nickname: String) -> AnyPublisher<NicknameValidationState, Never> {
        guard isValidStringLength(nickname) else {
            return .just(.exceededStringLength)
        }
        guard isChanged(nickname) else {
            return .just(.unchanged)
        }
        
        return duplicatedState(nickname)
    }
    
    private func duplicatedState(_ nickname: String) -> AnyPublisher<NicknameValidationState, Never> {
        return Future { promise in
            Task { [weak self] in
                guard let self else { return }
                do {
                    let isDuplicated = try await self.repository.checkDuplication(name: nickname)
                    promise(isDuplicated ? .success(.duplicated) : .success(.available))
                }
            }
        }.eraseToAnyPublisher()
    }
        
    private func isChanged(_ nickname: String) -> Bool {
        return profile.name != nickname
    }
    
    private func isValidStringLength(_ nickname: String) -> Bool {
        return nickname.count < 11
    }
    
    func update(_ profile: Profile) -> AnyPublisher<Profile, Error> {
        return Future { promise in
            Task { [weak self] in
                guard let self else { return }
                do {
                    let profile = try await self.repository.updateUserInfo(with: profile)
                    promise(.success(profile))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
