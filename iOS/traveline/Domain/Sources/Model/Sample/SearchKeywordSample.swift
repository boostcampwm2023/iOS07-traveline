//
//  SearchKeywordSample.swift
//  traveline
//
//  Created by 김영인 on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

enum SearchKeywordSample {
    static func makeRecentList() -> SearchKeywordList {
        return [
            .init(type: .recent, title: "여행간당"),
            .init(type: .recent, title: "얏호"),
            .init(type: .recent, title: "안녕하세요"),
            .init(type: .recent, title: "여수~밤바다~"),
            .init(type: .recent, title: "hi"),
            .init(type: .recent, title: "🚀")
        ]
    }
    
    static func makeRelatedList() -> SearchKeywordList {
        return [
            .init(type: .related, title: "안"),
            .init(type: .related, title: "안녕"),
            .init(type: .related, title: "안녕하"),
            .init(type: .related, title: "안녕하세"),
            .init(type: .related, title: "안녕하세요")
        ]
    }
}
