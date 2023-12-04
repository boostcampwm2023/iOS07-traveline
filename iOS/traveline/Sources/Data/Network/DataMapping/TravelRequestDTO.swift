//
//  TravelRequestDTO.swift
//  traveline
//
//  Created by 김영인 on 2023/11/30.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct TravelRequestDTO: Encodable {
    let title, location, startDate, endDate: String
    let headcount, budget, vehicle: String?
    let theme, withWho: [String]?
}

extension TravelRequest {
    func toDTO() -> TravelRequestDTO {
        .init(
            title: title,
            location: region,
            startDate: startDate.toString(),
            endDate: endDate.toString(),
            headcount: tags.filter { $0.type == .people }.first?.title,
            budget: (tags.filter { $0.type == .cost }.first?.title ?? "") + Literal.Tag.CostDetail.won,
            vehicle: tags.filter { $0.type == .transportation }.first?.title,
            theme: tags.filter { $0.type == .theme }.map(\.title),
            withWho: tags.filter { $0.type == .with }.map(\.title)
        )
    }
}
