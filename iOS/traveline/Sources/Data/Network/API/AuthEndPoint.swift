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
}

extension AuthEndPoint: EndPoint {
    var path: String? {
        switch self {
        case .withdrawal:
            return "/auth/withdrawal"
        case .login:
            return "/auth/login"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .withdrawal:
            return .DELETE
        case .login:
            return .POST
        }
    }
    
    var body: Encodable? {
        switch self {
        case .withdrawal(let requestDTO):
            return requestDTO
        case .login(let idToken):
            return idToken
        }
    }
    
}
