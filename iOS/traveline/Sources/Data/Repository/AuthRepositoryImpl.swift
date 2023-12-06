//
//  AuthRepositoryImpl.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/05.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

final class AuthRepositoryImpl: AuthRepository {
    
    private let network: NetworkType
    
    init(network: NetworkType) {
        self.network = network
    }
    
    func logout() {
        // TODO: - logout 로직 작성
    }
    
    func withdrawal() async throws {
        Task {
            do {
                let _ = try await network.requestWithNoResult(endPoint: AuthEndPoint.withdrawal)
            } catch {
                throw error
            }
        }
    }
    
}
