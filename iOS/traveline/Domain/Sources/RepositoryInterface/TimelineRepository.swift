//
//  TimelineRepository.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

protocol TimelineRepository {
    func fetchTimelineList(id: TravelID, day: Int) async throws -> TimelineCardList
}
