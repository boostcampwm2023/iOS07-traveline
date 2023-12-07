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
    
    var body: Encodable? {
        switch self {
        case .specificTimeline:
            return nil
            
        case .createTimeline(let timelineDetail):
            return timelineDetail
        }
    }
    
    var header: [String: String] {
        return [:]
    }
}
