//
//  AuthRepositoryImpl.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/05.
//  Copyright © 2023 traveline. All rights reserved.
//

import AuthenticationServices
import Foundation

final class AuthRepositoryImpl: AuthRepository {
    
    private let network: NetworkType
    
    init(network: NetworkType) {
        self.network = network
    }
    
    func logout() {
        KeychainList.accessToken = nil
        KeychainList.refreshToken = nil
    }
    
    func withdrawal() async throws -> Bool {
        guard let idToken = KeychainList.identityToken else { return false }
        guard let authorizationCode = KeychainList.authorizationCode else { return false }
        
        let withdrawRequestDTO: WithdrawRequestDTO = .init(
            idToken: idToken,
            authorizationCode: authorizationCode
        )
        
        let result = try await network.request(endPoint: AuthEndPoint.withdrawal(withdrawRequestDTO), type: Bool.self)
        
        KeychainList.allClear()
        
        return result
    }
    
}
