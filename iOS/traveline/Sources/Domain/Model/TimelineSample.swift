//
//  TimelineSample.swift
//  traveline
//
//  Created by 김태현 on 11/22/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

// TODO: - 서버 연동시 지우기
enum TimelineSample {
    static func makeTravelInfo() -> TimelineTravelInfo {
        return .init(
            travelTitle: "서울 여행 ~",
            startDate: "2023.11.21",
            endDate: "2023.11.23",
            isLiked: true,
            tags: [
                .init(title: "2박 3일", type: .period),
                .init(title: "서울", type: .location),
                .init(title: "가을", type: .season),
                .init(title: "맛집", type: .theme),
                .init(title: "힐링", type: .theme),
                .init(title: "액티비티", type: .theme),
                .init(title: "힐링", type: .theme)
            ]
        )
    }
}
