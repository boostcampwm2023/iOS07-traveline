//
//  EndPoint.swift
//  traveline
//
//  Created by 김영인 on 2023/11/14.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

protocol EndPoint {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var body: Encodable? { get }
    var header: [String: String] { get }
}

extension EndPoint {
    var baseURL: String {
        return "baseURL"
    }
}
