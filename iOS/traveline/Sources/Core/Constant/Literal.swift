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
        static let costSubtitle: String = "단위: 만원"
        static let people: String = "인원"
        static let with: String = "함께"
        static let transportation: String = "이동수단"
        
        enum ThemeDetail {
            static let healing: String = "힐링"
            static let activity: String = "액티비티"
            static let camping: String = "캠핑"
            static let restaurant: String = "맛집"
            static let art: String = "예술"
            static let emotion: String = "감성"
            static let nature: String = "자연"
            static let shopping: String = "쇼핑"
            static let filialPiety: String = "효도"
        }
        
        enum CostDetail {
            static let under10: String = "0 - 10"
            static let under50: String = "10 - 50"
            static let under100: String = "50 - 100"
            static let over100: String = "100 -"
        }
        
        enum PeopleDetail {
            static let one: String = "1인"
            static let two: String = "2인"
            static let three: String = "3인"
            static let four: String = "4인"
            static let overFive: String = "5인 이상"
        }
        
        enum WithDetail {
            static let family: String = "가족"
            static let friend: String = "친구"
            static let couple: String = "연인"
            static let pet: String = "반려동물"
        }
        
        enum TransportationDetail {
            static let publicTransport: String = "대중교통"
            static let drive: String = "자차"
        }
    }
}
