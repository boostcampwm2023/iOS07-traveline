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
    case createPosting(TravelRequestDTO) /// 여행 생성
    case putPosting(String, TravelRequestDTO) /// 여행 수정
    case deletePosting(String) /// 여행 삭제
    case fetchPostingInfo(String) /// 특정 여행 반환
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
            
        case let .putPosting(id, _),
            let .deletePosting(id),
            let .fetchPostingInfo(id):
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
            
        case .deletePosting:
            return .DELETE
            
        default:
            return .GET
        }
    }
    
    var body: Encodable? {
        switch self {
        case let .createPosting(travel),
            let .putPosting(_, travel):
            return travel
            
        default:
            return nil
        }
    }
    
    var header: HeaderType {
        return .authorization
    }
}
