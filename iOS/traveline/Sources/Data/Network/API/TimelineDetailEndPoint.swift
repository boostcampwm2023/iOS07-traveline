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
}

extension TimelineDetailEndPoint: EndPoint {
    
    var path: String? {
        switch self {
        case .specificTimeline(let id):
            return "/timelines/\(id)"
            
        case .createTimeline:
            return "/timelines"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .specificTimeline:
            return .GET
            
        case .createTimeline:
            return .POST
        }
    }
    
    var multipartData: Any? {
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
