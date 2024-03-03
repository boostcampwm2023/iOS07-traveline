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
            selected: [DetailFilter.region(RegionFilter.busan), DetailFilter.region(RegionFilter.daejeon)]
        )
    }
    
    static func makePeriod() -> Filter {
        .init(
            type: .tagtype(.period),
            selected: [DetailFilter.period(PeriodFilter.overThree)]
        )
    }
}
