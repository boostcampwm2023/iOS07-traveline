//
//  UserRepositoryImpl.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/04.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

final class UserRepositoryImpl: UserRepository {
    
    private let network: NetworkType
    
    init(network: NetworkType) {
        self.network = network
    }
    
    func fetchUserInfo() async throws -> Profile {
        if let userResponseDTO = UserDefaultsList.userResponseDTO {
            return userResponseDTO.toDomain()
        }
        
        let userResponseDTO = try await network.request(
            endPoint: UserEndPoint.requestUserInfo,
            type: UserResponseDTO.self
        )
        
        UserDefaultsList.userResponseDTO = userResponseDTO
        
        return userResponseDTO.toDomain()
    }
    
    func updateUserInfo(name: String, imageData: Data?) async throws -> Profile {
        let userRequestDTO: UserRequestDTO = .init(name: name, image: imageData)
        
        let userResponseDTO = try await network.request(
            endPoint: UserEndPoint.updateUserInfo(userRequestDTO),
            type: UserResponseDTO.self
        )
        
        UserDefaultsList.userResponseDTO = userResponseDTO
        
        return userResponseDTO.toDomain()
    }
    
    func checkDuplication(name: String) async throws -> Bool {
        let duplicatedNameResponseDTO = try await network.request(
            endPoint: UserEndPoint.checkDuplicatedName(name),
            type: DuplicatedNameResponseDTO.self
        )
        
        return duplicatedNameResponseDTO.isDuplicated
    }
    
    func blockUser(id: UserID) async throws -> Bool {
        let blockUserResponseDTO = try await network.requestWithNoResult(endPoint: UserEndPoint.blockUser(id.value))
        
        return blockUserResponseDTO
    }
}
