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
}

extension TimelineDetailEndPoint: EndPoint {
    var path: String {
        switch self {
        case .specificTimeline(let id): return "/timelines/\(id)"
        }
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
