//
//  TimelineDetailRequestDTO.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/05.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Domain

struct TimelineDetailRequestDTO: MultipartData {
    let title: String
    let day: Int
    let description: String
    var image: Data?
    let coordX: Double?
    let coordY: Double?
    let date: String
    let place: String?
    let time: String
    let posting: String
}

extension TimelineDetailRequest {
    func toDTO() -> TimelineDetailRequestDTO {
        return .init(
            title: title,
            day: day,
            description: content,
            image: image,
            coordX: place?.latitude,
            coordY: place?.longitude,
            date: date,
            place: place?.title,
            time: time.convertTimeFormat(from: "a hh:mm", to: "HH:mm") ?? "00:00",
            posting: posting
        )
    }
}
