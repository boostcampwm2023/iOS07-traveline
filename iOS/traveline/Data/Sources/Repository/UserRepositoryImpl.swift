//
//  UserRepositoryImpl.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/04.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Domain

public final class UserRepositoryImpl: UserRepository {
    
    private let network: NetworkType
    
    public init(network: NetworkType) {
        self.network = network
    }
    
    public func fetchUserInfo() async throws -> Profile {
        if let profile = UserDefaultsList.profile {
            return profile
        }
        
        let userResponseDTO = try await network.request(
            endPoint: UserEndPoint.requestUserInfo,
            type: UserResponseDTO.self
        )
        
        return userResponseDTO.toDomain()
    }
    
    public func updateUserInfo(name: String, imageData: Data?) async throws -> Profile {
        let userRequestDTO: UserRequestDTO = .init(name: name, image: imageData)
        
        let userResponseDTO = try await network.request(
            endPoint: UserEndPoint.updateUserInfo(userRequestDTO),
            type: UserResponseDTO.self
        )
        
        return userResponseDTO.toDomain()
    }
    
    public func checkDuplication(name: String) async throws -> Bool {
        let duplicatedNameResponseDTO = try await network.request(
            endPoint: UserEndPoint.checkDuplicatedName(name),
            type: DuplicatedNameResponseDTO.self
        )
        
        return duplicatedNameResponseDTO.isDuplicated
    }
}
