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
    case fetchPlaceList(String)
}

extension TimelineDetailEndPoint: EndPoint {
    
    var path: String? {
        let curPath = "/timelines"
        
        switch self {
        case .specificTimeline(let id):
            return "\(curPath)/\(id)"
            
        case let .fetchPlaceList(keyword):
            return "\(curPath)/map?place=\(keyword)"
            
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
        }
    }
    
    var multipartData: MultipartData? {
        switch self {
        case .createTimeline(let timelineDetail):
            return timelineDetail
            
        default:
            return nil
        }
    }
    
    var header: HeaderType {
        switch self {
        case .createTimeline:
            return .multipart
            
        default:
            return .authorization
        }
    }
}
