//
//  TimelineDetailEndPoint.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/02.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum TimelineDetailEndPoint {
    case specificTimeline(String)
    case createTimeline(TimelineDetailRequestDTO)
    case fetchPlaceList(String, Int)
    case putTimeline(String, TimelineDetailRequestDTO)
    case deleteTimeline(String)
}

extension TimelineDetailEndPoint: EndPoint {
    
    var path: String? {
        let curPath = "/timelines"
        
        switch self {
        case .specificTimeline(let id):
            return "\(curPath)/\(id)"
            
        case let .fetchPlaceList(keyword, offset):
            return "\(curPath)/map?place=\(keyword)&offset=\(offset)"
            
        case .putTimeline(let id, _):
            return "\(curPath)/\(id)"
            
        case .deleteTimeline(let id):
            return "\(curPath)/\(id)"
            
        default:
            return curPath
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .specificTimeline, .fetchPlaceList:
            return .GET
            
        case .createTimeline:
            return .POST
            
        case .putTimeline:
            return .PUT
            
        case .deleteTimeline:
            return .DELETE
        }
    }
    
    var multipartData: MultipartData? {
        switch self {
        case .createTimeline(let timelineDetail):
            return timelineDetail
            
        case .putTimeline(_, let timelineDetail):
            return timelineDetail
            
        default:
            return nil
        }
    }
    
    var header: HeaderType {
        switch self {
        case .createTimeline, .putTimeline:
            return .multipart
            
        default:
            return .authorization
        }
    }
}
