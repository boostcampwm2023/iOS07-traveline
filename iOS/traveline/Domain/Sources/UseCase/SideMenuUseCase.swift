//
//  SideMenuUseCase.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/05.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

public protocol SideMenuUseCase {
    func fetchProfile() -> AnyPublisher<Profile, Error>
}

public final class SideMenuUseCaseImpl: SideMenuUseCase {
    
    private let repository: UserRepository
    
    public init(repository: UserRepository) {
        self.repository = repository
    }
    
    public func fetchProfile() -> AnyPublisher<Profile, Error> {
        return Future {
            let profile = try await self.repository.fetchUserInfo()
            UserDefaultsList.profile = profile
            return profile
        }.eraseToAnyPublisher()
    }
    
}
