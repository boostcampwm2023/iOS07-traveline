//
//  TimelineEndPoint.swift
//  traveline
//
//  Created by 김영인 on 2023/12/05.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum TimelineEndPoint {
    case fetchTimelines(FetchTimelineRequestDTO) /// 게시글의 Day N에 해당하는 모든 타임라인 반환
}

extension TimelineEndPoint: EndPoint {
    
    var path: String? {
        let curPath: String = "/timelines"
        
        switch self {
        case let .fetchTimelines(info):
            return "\(curPath)?postingId=\(info.id)&day=\(info.day)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .GET
    }
    
    var body: Encodable? {
        return nil
    }
    
    var header: HeaderType {
        return .authorization
    }
}
