//
//  PostingEndPoint.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum PostingEndPoint {
    case postingList(SearchQuery)
    case myPostingList
    case createPosting(TravelRequestDTO) /// 게시글 생성
    case fetchPostingInfo(String) /// 특정 게시글 반환
    case specificPosting
}

extension PostingEndPoint: EndPoint {
    
    var path: String? {
        let curPath: String = "/postings"
        
        switch self {
        case .myPostingList: 
            return "/postings/mine"
        case let .postingList(searchQuery):
            return curPath + searchQuery.makeQuery()
        case let .fetchPostingInfo(id):
            return "\(curPath)/\(id)"
        default:
            return curPath
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .createPosting:
            return .POST
        default:
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
