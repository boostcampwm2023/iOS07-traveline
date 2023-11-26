//
//  FilterSample.swift
//  traveline
//
//  Created by 김영인 on 2023/11/26.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum FilterSample {
    static func makeLocation() -> Filter {
        .init(
            type: .tagtype(.location),
            selected: [Literal.Filter.LocationDetail.busan, Literal.Filter.LocationDetail.daejeon]
        )
    }
    
    static func makePeriod() -> Filter {
        .init(
            type: .tagtype(.period),
            selected: [Literal.Filter.PeriodDetail.overThree]
        )
    }
}
