//
//  AuthEndPoint.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/05.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum AuthEndPoint {
    case withdrawal
}

extension AuthEndPoint: EndPoint {
    var path: String? {
        return "/auth/withdrawal"
    }
    
    var httpMethod: HTTPMethod {
        return .DELETE
    }
    
    var body: Encodable? {
        return nil
    }
}
