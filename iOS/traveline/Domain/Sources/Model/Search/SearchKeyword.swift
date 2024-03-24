//
//  SearchKeyword.swift
//  traveline
//
//  Created by 김영인 on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

public typealias SearchKeywordList = [SearchKeyword]

public struct SearchKeyword: Hashable {
    public let type: SearchViewType
    public let title: String
    public var searchedKeyword: String?
    
    public init(type: SearchViewType, title: String, searchedKeyword: String? = nil) {
        self.type = type
        self.title = title
        self.searchedKeyword = searchedKeyword
    }
}
