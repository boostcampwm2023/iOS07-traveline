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
    case updateUserInfo(UserRequestDTO)
    case checkDuplicatedName(String)
}

extension UserEndPoint: EndPoint {
    var path: String? {
        switch self {
        case .checkDuplicatedName(let name):
            return "/users/duplicate?name=\(name)"
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
    
    var multipartData: MultipartData? {
        switch self {
        case .updateUserInfo(let user):
            return user
        default:
            return nil
        }
    }
    
    var header: HeaderType {
        switch self {
        case .updateUserInfo:
            return .multipart
        default:
            return .authorization
        }
    }
}
