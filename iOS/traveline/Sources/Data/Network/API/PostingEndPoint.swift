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
    case putPosting(String, TravelRequestDTO) /// 게시글 수정
    case fetchPostingInfo(String) /// 특정 게시글 반환
    case specificPosting
    case postingTitleList(String)
}

extension PostingEndPoint: EndPoint {
    
    var path: String? {
        let curPath: String = "/postings"
        
        switch self {
        case .myPostingList: 
            return "/postings/mine"
            
        case let .postingList(searchQuery):
            return curPath + searchQuery.makeQuery()
            
        case let .putPosting(id, _):
            return "\(curPath)/\(id)"
            
        case let .fetchPostingInfo(id):
            return "\(curPath)/\(id)"
            
        case let .postingTitleList(keyword):
            return "\(curPath)/titles?keyword=\(keyword)"
            
        default:
            return curPath
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .createPosting:
            return .POST
            
        case .putPosting:
            return .PUT
            
        default:
            return .GET
        }
    }
    
    var body: Encodable? {
        switch self {
        case let .createPosting(travel):
            return travel
            
        case let .putPosting(_, travel):
            return travel
            
        default:
            return nil
        }
    }
    
    var header: HeaderType {
        return .authorization
    }
}
