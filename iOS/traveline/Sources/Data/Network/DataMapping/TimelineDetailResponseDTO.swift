//
//  TimelineDetailResponseDTO.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/02.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct TimelineDetailResponseDTO: Decodable {
    let id: String
    let title: String
    let day: Int
    let description: String
    let image: String?
    let coordX: Double?
    let coordY: Double?
    let date: String
    let place: String
    let time: String
}

// MARK: - Mapping

extension TimelineDetailResponseDTO {
    func toDomain() -> TimelineDetailInfo {
        return .init(
            id: id,
            title: title,
            day: day,
            description: description,
            imageURL: image,
            coordX: coordX,
            coordY: coordY,
            date: date,
            location: place,
            time: time
        )
    }
    
}
