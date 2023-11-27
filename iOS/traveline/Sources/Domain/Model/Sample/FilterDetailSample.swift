//
//  FilterSample.swift
//  traveline
//
//  Created by 김영인 on 2023/11/26.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum FilterSample {
    static func makeRegion() -> Filter {
        .init(
            type: .tagtype(.region),
            selected: [Literal.Filter.RegionDetail.busan, Literal.Filter.RegionDetail.daejeon]
        )
    }
    
    static func makePeriod() -> Filter {
        .init(
            type: .tagtype(.period),
            selected: [Literal.Filter.PeriodDetail.overThree]
        )
    }
}
