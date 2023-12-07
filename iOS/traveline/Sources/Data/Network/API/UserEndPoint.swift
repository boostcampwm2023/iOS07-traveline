//
//  UserEndPoint.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/04.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum UserEndPoint {
    case requestUserInfo
    case updateUserInfo
    case checkDuplicatedName
}

extension UserEndPoint: EndPoint {
    var path: String? {
        switch self {
        case .checkDuplicatedName:
            return "/users/duplicate"
        case .requestUserInfo:
            return "/users"
        default:
            return "/users"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .updateUserInfo:
            return .PUT
        case .requestUserInfo:
            return .GET
        default:
            return .GET
        }
    }
    
    var body: Encodable? {
        return nil
    }
    
    var header: HeaderType {
        return .authorization
    }
}
