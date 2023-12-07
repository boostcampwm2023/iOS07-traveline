//
//  EndPoint.swift
//  traveline
//
//  Created by 김영인 on 2023/11/14.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

protocol EndPoint {
    var path: String? { get }
    var httpMethod: HTTPMethod { get }
    var body: Encodable? { get }
    var multipartData: Any? { get }
    var header: HeaderType { get }
}

extension EndPoint {
    
    var baseURL: String? {
        return Bundle.main.object(forInfoDictionaryKey: Literal.InfoPlistKey.baseURL) as? String
    }
    
    var body: Encodable? {
        return nil
    }
    
    var multipartData: Any? {
        return nil
    }
    
    var header: HeaderType {
        return .json
    }
}
