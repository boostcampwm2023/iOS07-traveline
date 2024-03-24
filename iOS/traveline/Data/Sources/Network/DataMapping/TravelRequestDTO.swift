//
//  TravelRequestDTO.swift
//  traveline
//
//  Created by 김영인 on 2023/11/30.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Domain

struct TravelRequestDTO: Encodable {
    let title, location, startDate, endDate: String
    let headcount, budget, vehicle: String?
    let theme, withWho: [String]?
}

extension TravelRequest {
    func toDTO() -> TravelRequestDTO {
        let tagManager = TagManager.init(tags: tags)
        
        var costTag: String?
        if var cost: String = tagManager.toDTO(type: .cost) {
            costTag = cost == Literal.Tag.CostDetail.over100 ?
            Literal.Query.CostDetail.over100 :
            cost + Literal.Tag.CostDetail.won
        }
        
        return .init(
            title: title,
            location: region,
            startDate: startDate.toString(),
            endDate: endDate.toString(),
            headcount: tagManager.toDTO(type: .people),
            budget: costTag,
            vehicle: tagManager.toDTO(type: .transportation),
            theme: tagManager.toDTO(type: .theme),
            withWho: tagManager.toDTO(type: .with)
        )
    }
}
