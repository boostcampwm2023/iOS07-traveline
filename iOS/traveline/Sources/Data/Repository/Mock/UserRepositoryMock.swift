//
//  UserRepositoryMock.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/04.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

final class UserRepositoryMock: UserRepository {
    
    private let alreadyNames: [String] = [
        "0inn",
        "hongki",
        "kth1210",
        "kmi0817",
        "yaongmeow"
    ]
    func fetchUserInfo() async throws -> Profile {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        let mockData: Profile = .init(
            imageURL: "https://avatars.githubusercontent.com/u/91725382?s=400&u=29b8023a56a09685aaab53d4eb0dd556254cd902&v=4",
            name: "hongki"
        )
        return mockData
    }
    
    func updateUserInfo(with newProfile: Profile) async throws -> Profile {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        return newProfile
    }
    
    func checkDuplication(name: String) async throws -> Bool {
        try await Task.sleep(nanoseconds: 1_000_000)
        
        return alreadyNames.contains(name)
    }
}
