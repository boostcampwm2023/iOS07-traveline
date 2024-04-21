//
//  AuthEndPoint.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/05.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum AuthEndPoint {
    case appleLogin(AppleLoginRequestDTO)
    case withdrawal(WithdrawRequestDTO)
    case refresh
}

extension AuthEndPoint: EndPoint {
    var path: String? {
        switch self {
        case .withdrawal:
            return "/auth/withdraw/apple"
        case .appleLogin:
            return "/auth/login/apple"
        case .refresh:
            return "/auth/refresh"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .withdrawal:
            return .DELETE
        case .appleLogin:
            return .POST
        case .refresh:
            return .GET
        }
    }
    
    var body: Encodable? {
        switch self {
        case .withdrawal(let requestDTO):
            return requestDTO
        case .appleLogin(let idToken):
            return idToken
        case .refresh:
            return nil
        }
    }
    
    var header: HeaderType {
        switch self {
        case .withdrawal:
            return .authorization
        case .appleLogin:
            return .json
        case .refresh:
            return .refresh
        }
    }

}
