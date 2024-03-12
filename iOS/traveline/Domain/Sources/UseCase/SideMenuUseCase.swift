//
//  SideMenuUseCase.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/05.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

protocol SideMenuUseCase {
    func fetchProfile() -> AnyPublisher<Profile, Error>
}

final class SideMenuUseCaseImpl: SideMenuUseCase {
    
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func fetchProfile() -> AnyPublisher<Profile, Error> {
        return Future {
            let profile = try await self.repository.fetchUserInfo()
            UserDefaultsList.profile = profile
            return profile
        }.eraseToAnyPublisher()
    }
    
}
