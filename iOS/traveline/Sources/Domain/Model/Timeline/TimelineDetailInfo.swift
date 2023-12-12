//
//  TimelineDetail.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/22.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct TimelineDetailInfo: Hashable {
    let postingID: String
    let id: String
    let title: String
    let day: Int
    let description: String
    let imageURL: String?
    let coordX: Double?
    let coordY: Double?
    let date: String
    let location: String
    let time: String
    let isOwner: Bool
    
    static let empty: TimelineDetailInfo = .init(
        postingID: Literal.empty,
        id: Literal.empty,
        title: Literal.empty,
        day: 0,
        description: Literal.empty,
        imageURL: nil,
        coordX: nil,
        coordY: nil,
        date: Literal.empty,
        location: Literal.empty,
        time: Literal.empty,
        isOwner: false
    )
    
    static let sample: TimelineDetailInfo = .init(
        postingID: "9a0396ba-4892-436a-a97c-58be59b59327",
        id: "ae12a997-159c-40d1-b3c6-62af7fd981d1",
        title: "두근두근 출발 날 😍",
        day: 1,
        description: "서울역의 상징성은 정치적으로도 연관이 깊다. 이는 신의 한 수가 된다. 영서 지방은 ITX-청춘 용산발 춘천행, DMZ-train 서울발 백마고지행 둘뿐이었다.",
        imageURL: "https://user-images.githubusercontent.com/51712973/280571628-e1126b86-4941-49fc-852b-9ce16f3e0c4e.jpg",
        coordX: 100.1,
        coordY: 100.3,
        date: "2023-08-16",
        location: "서울역",
        time: "07:30",
        isOwner: false
    )
}
