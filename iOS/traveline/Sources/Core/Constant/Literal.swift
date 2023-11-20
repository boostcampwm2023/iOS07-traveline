//
//  Literal.swift
//  traveline
//
//  Created by 김영인 on 2023/11/17.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum Literal {
    static let empty: String = ""
    
    enum Tag {
        static let location: String = "위치"
        static let period: String = "기간"
        static let season: String = "계절"
        static let theme: String = "테마"
        static let cost: String = "비용"
        static let people: String = "인원"
        static let with: String = "함께"
        static let transportation: String = "이동수단"
    }
}
