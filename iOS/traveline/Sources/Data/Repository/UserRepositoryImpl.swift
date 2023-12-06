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
        // TODO: - Request UIser Info 로직 추가
        return .empty
    }
    
    func checkDuplication(name: String) async throws -> Bool {
        return try await network.request(
            endPoint: UserEndPoint.checkDuplicatedName,
            type: Bool.self
        )
    }
}
