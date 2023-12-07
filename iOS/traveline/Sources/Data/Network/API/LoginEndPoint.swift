//
//  LoginEndPoint.swift
//  traveline
//
//  Created by 김영인 on 2023/11/14.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum LoginEndPoint {
    case signup
    case logout
}

extension LoginEndPoint: EndPoint {
    var path: String? {
        switch self {
        case .logout:
            return "/logout"
        case .signup:
            return "/signup"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .POST
    }
    
    var body: Encodable? {
        return nil
    }
    
    var header: [String: String] {
        return HeaderType.json.value
    }
}
