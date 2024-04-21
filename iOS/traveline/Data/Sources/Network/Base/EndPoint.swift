//
//  EndPoint.swift
//  traveline
//
//  Created by 김영인 on 2023/11/14.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

public protocol EndPoint {
    var path: String? { get }
    var httpMethod: HTTPMethod { get }
    var body: Encodable? { get }
    var multipartData: MultipartData? { get }
    var header: HeaderType { get }
}

extension EndPoint {
    
    var baseURL: String? {
        #if DEBUG
        return Bundle.main.object(forInfoDictionaryKey: Literal.InfoPlistKey.devURL) as? String
        #else
        return Bundle.main.object(forInfoDictionaryKey: Literal.InfoPlistKey.prodURL) as? String
        #endif
    }
    
    var body: Encodable? {
        return nil
    }
    
    var multipartData: MultipartData? {
        return nil
    }
    
    var header: HeaderType {
        return .json
    }
}
