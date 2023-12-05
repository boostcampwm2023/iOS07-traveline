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
        let tagManager = TagManager.init(tags: tags)
        
        return .init(
            title: title,
            location: region,
            startDate: startDate.toString(),
            endDate: endDate.toString(),
            headcount: tagManager.toDTO(type: .people),
            budget: (tagManager.toDTO(type: .cost) ?? "0") + Literal.Tag.CostDetail.won,
            vehicle: tagManager.toDTO(type: .transportation),
            theme: tagManager.toDTO(type: .theme),
            withWho: tagManager.toDTO(type: .with)
        )
    }
}
