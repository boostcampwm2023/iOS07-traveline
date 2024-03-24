//
//  SearchQuery.swift
//  traveline
//
//  Created by 김태현 on 12/4/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

protocol Query {
    func makeQuery() -> String
}

public struct SearchQuery: Query {
    var keyword: String?
    var offset: Int = 1
    var limit: Int = 20
    var selectedFilter: [DetailFilter]?
    
    func makeQuery() -> String {
        let baseQuery = "?"
        var queries: [String] = []
        queries.append("offset=\(offset)")
        queries.append("limit=\(limit)")
        
        if let keyword { queries.append("keyword=\(keyword)") }

        if let selectedFilter {
            selectedFilter.forEach {
                switch $0 {
                case let .sort(sorting):
                    queries.append("sorting=\(sorting.query)")
                case let .theme(theme):
                    queries.append("theme[]=\(theme.query)")
                case let .region(location):
                    queries.append("location[]=\(location.query)")
                case let .cost(budget):
                    queries.append("budget=\(budget.query)")
                case let .people(headcount):
                    queries.append("headcount=\(headcount.query)")
                case let .with(withWho):
                    queries.append("withWho[]=\(withWho.query)")
                case let .transportation(vehicle):
                    queries.append("vehicle=\(vehicle.query)")
                case let .period(period):
                    queries.append("period=\(period.query)")
                case let .season(season):
                    queries.append("season[]=\(season.query)")
                }
            }
        }
        
        if !queries.isEmpty,
           let resultQuery = (baseQuery + queries.joined(separator: "&"))
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return resultQuery
        } else {
            return Literal.empty
        }
    }
}
