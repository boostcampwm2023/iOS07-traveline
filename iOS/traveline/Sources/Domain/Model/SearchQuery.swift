//
//  SearchQuery.swift
//  traveline
//
//  Created by 김태현 on 12/4/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

protocol Query {
    func makeQuery() -> String
}

struct SearchQuery: Query {
    var keyword: String?
    var offset: Int?
    var limit: Int?
    var selectedFilter: [DetailFilter]?
    
    func makeQuery() -> String {
        guard let selectedFilter else { return Literal.empty }
        let baseQuery = "?"
        var queries: [String] = []
        
        if let keyword { queries.append("keyword=\(keyword)") }
        if let offset { queries.append("offset=\(offset)") }
        if let limit { queries.append("limit=\(limit)") }

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
        
        if !queries.isEmpty,
           let resultQuery = (baseQuery + queries.joined(separator: "&"))
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return resultQuery
        } else {
            return Literal.empty
        }
    }
}
