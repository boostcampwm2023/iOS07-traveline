//
//  TimelineDetailRepository.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/02.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

protocol TimelineDetailRepository {
    func fetchTimelineDetailInfo(id: String) async throws -> TimelineDetailInfo
}
