//
//  HeaderType.swift
//  traveline
//
//  Created by 김영인 on 2023/12/01.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core
import Domain

public enum HeaderType {
    case json
    case authorization
    case refresh
    case multipart
    
    var value: [String: String] {
        switch self {
        case .json:
            return [
                "Content-Type": "application/json"
            ]
            
        case .authorization:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(KeychainList.accessToken ?? "EMPTY")"
            ]
            
        case .refresh:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(KeychainList.refreshToken ?? "EMPTY")"
            ]
            
        case .multipart:
            return [
                "Content-Type": "multipart/form-data; boundary=\(Literal.boundary)",
                "Authorization": "Bearer \(KeychainList.accessToken ?? "EMPTY")"
            ]
        }
    }
}
