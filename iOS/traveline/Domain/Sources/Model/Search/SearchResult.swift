//
//  SearchResult.swift
//  traveline
//
//  Created by 김태현 on 12/6/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

public struct SearchResult {
    public let keyword: String
    public let travelList: TravelList
    
    public init(keyword: String, travelList: TravelList) {
        self.keyword = keyword
        self.travelList = travelList
    }
}
