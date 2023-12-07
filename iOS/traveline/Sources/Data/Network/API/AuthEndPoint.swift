//
//  AuthEndPoint.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/05.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum AuthEndPoint {
    case login(LoginRequestDTO)
    case withdrawal(WithdrawRequestDTO)
    case refresh
}

extension AuthEndPoint: EndPoint {
    var path: String? {
        switch self {
        case .withdrawal:
            return "/auth/withdrawal"
        case .login:
            return "/auth/login"
        case .refresh:
            return "/auth/refresh"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .withdrawal:
            return .DELETE
        case .login:
            return .POST
        case .refresh:
            return .GET
        }
    }
    
    var body: Encodable? {
        switch self {
        case .withdrawal(let requestDTO):
            return requestDTO
        case .login(let idToken):
            return idToken
        case .refresh:
            return nil
        }
    }
    
    var header: HeaderType {
        switch self {
        case .withdrawal:
            return .authorization
        case .login:
            return .json
        case .refresh:
            return .refresh
        }
    }

}
