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
    var sorting: SortFilter?
    var offset: Int?
    var limit: Int?
    var period: PeriodFilter?
    var headcount: PeopleTag?
    var budget: CostTag?
    var vehicle: TransportationTag?
    var location: [RegionFilter]?
    var theme: [ThemeTag]?
    var withWho: [WithTag]?
    var season: [SeasonFilter]?
    
    func makeQuery() -> String {
        let baseQuery = "?"
        var queries: [String] = []
        if let keyword { queries.append("keyword=\(keyword)") }
        if let sorting { queries.append("sorting=\(sorting.query)") }
        if let offset { queries.append("offset=\(offset)") }
        if let limit { queries.append("limit=\(limit)") }
        if let period { queries.append("period=\(period.query)") }
        if let headcount { queries.append("headcount=\(headcount.query)") }
        if let budget { queries.append("budget=\(budget.query)") }
        if let vehicle { queries.append("vehicle=\(vehicle.query)") }
        if let location { location.forEach { queries.append("location[]=\($0.query)") } }
        if let theme { theme.forEach { queries.append("theme[]=\($0.query)") } }
        if let withWho { withWho.forEach { queries.append("withWho[]=\($0.query)") } }
        if let season { season.forEach { queries.append("season[]=\($0.query)") } }
        
        if !queries.isEmpty,
           let resultQuery = (baseQuery + queries.joined(separator: "&"))
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return resultQuery
        } else {
            return Literal.empty
        }
    }
}
