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
        default:
            return "/users"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .updateUserInfo:
            return .PUT
        default:
            return .GET
        }
    }
    
    var body: Encodable? {
        return nil
    }
    
    var header: [String: String] {
        return HeaderType.json.value
    }
}
