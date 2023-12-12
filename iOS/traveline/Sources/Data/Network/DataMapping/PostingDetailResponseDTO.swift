//
//  PostingDetailResponseDTO.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct PostingDetailResponseDTO: Decodable {
    let id: String
    let title: String
    let createdAt: String
    let thumbnail: String?
    let startDate: String
    let endDate: String
    let days: [String]
    let period: String
    let headcount: String?
    let budget: String?
    let location: String
    let season: String
    let vehicle: String?
    let theme: [String]?
    let withWho: [String]?
    let writer: WriterDTO
    let likeds: Int
    let reports: Int
    let isLiked: Bool
    let isOwner: Bool
}

// MARK: - Mapping

extension PostingDetailResponseDTO {
    func toDomain() -> TimelineTravelInfo {
        .init(
            travelTitle: title,
            startDate: startDate,
            endDate: endDate,
            isLiked: isLiked, 
            isOwner: isOwner,
            tags: toTags(),
            days: days,
            day: 1
        )
    }
    
    private func toTags() -> [Tag] {
        var tags: [Tag] = [
            Tag(title: location, type: .region),
            Tag(title: period, type: .period),
            Tag(title: season, type: .season)
        ]
        
        if let people = headcount {
            tags.append(Tag(title: people, type: .people))
        }
        if let cost = budget {
            tags.append(Tag(title: cost, type: .cost))
        }
        if let transportation = vehicle {
            tags.append(Tag(title: transportation, type: .transportation))
        }
        if let theme {
            theme.forEach { tags.append(Tag(title: $0, type: .theme)) }
        }
        if let with = withWho {
            with.forEach { tags.append(Tag(title: $0, type: .with)) }
        }
        
        return tags
    }
}
