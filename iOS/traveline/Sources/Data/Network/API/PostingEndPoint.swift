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
    case myPostingList
    case createPosting(TravelRequestDTO)
    case specificPosting
}

extension PostingEndPoint: EndPoint {
    
    var path: String? {
        let curPath: String = "/postings"
        
        switch self {
        case .myPostingList: return "/postings/mine"
        case .postingList, .createPosting:
            return curPath
        case .specificPosting:
            return "/postings"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .createPosting:
            return .POST
        case .postingList, .specificPosting, .myPostingList:
            return .GET
        }
    }
    
    var body: Encodable? {
        switch self {
        case let .createPosting(travel):
            return travel
        default:
            return nil
        }
    }
    
    var header: [String: String] {
        return HeaderType.authorization.value
    }
}
