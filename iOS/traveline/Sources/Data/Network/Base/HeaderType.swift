//
//  HeaderType.swift
//  traveline
//
//  Created by 김영인 on 2023/12/01.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum HeaderType {
    case json
    case authorization
    case multipart
    
    var value: [String: String] {
        switch self {
        case .json:
            let header = [
                "Content-Type": "application/json"
            ]
            
            return header
            
        case .authorization:
            let header = [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(KeychainList.accessToken ?? "EMPTY")"
            ]
            
            return header
            
        case .multipart:
            let header = [
                "Content-Type": "application/json"
            ]
            
            return header
        }
    }
}
