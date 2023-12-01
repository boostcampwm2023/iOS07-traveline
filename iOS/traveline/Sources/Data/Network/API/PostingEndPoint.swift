//
//  PostingEndPoint.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum PostingEndPoint {
    case postingList
    case specificPosting
}

extension PostingEndPoint: EndPoint {
    var path: String {
        return "/postings"
    }
    
    var httpMethod: HTTPMethod {
        return .GET
    }
    
    var body: Encodable? {
        return nil
    }
    
    var header: [String: String] {
        return [:]
    }
}
