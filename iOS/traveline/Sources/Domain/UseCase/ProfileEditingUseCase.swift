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
    func validate(nickname: String) -> AnyPublisher<NicknameValidationState, Error>
    func update(name: String, imageData: Data?) -> AnyPublisher<Profile, Error>
}

enum NicknameValidationState {
    case unchanged
    case tooShort
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
    
    func validate(nickname: String) -> AnyPublisher<NicknameValidationState, Error> {
        return Future { promise in
            Task {
                guard self.isTooShort(nickname) == false else {
                    return promise(.success(.tooShort))
                }
                guard self.isValidStringLength(nickname) else {
                    return promise(.success(.exceededStringLength))
                }
                guard self.isChanged(nickname) else {
                    return promise(.success(.unchanged))
                }
                do {
                    let isDuplicated = try await self.repository.checkDuplication(name: nickname)
                    promise(isDuplicated ? .success(.duplicated) : .success(.available))
                } catch {
                    promise(.failure(error))
                }
            }
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
        return Future { promise in
            Task { [weak self] in
                guard let self else { return }
                do {
                    let profile = try await self.repository.updateUserInfo(name: name, imageData: imageData)
                    promise(.success(profile))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
