//
//  TravelRegion.swift
//  traveline
//
//  Created by 김태현 on 11/26/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum TravelRegion: CaseIterable {
    case seoul
    case busan
    case daegu
    case incheon
    case gwangju
    case daejeon
    case ulsan
    case sejong
    case gyeonggi
    case gangwon
    case chungbuk
    case chungnam
    case jeonbuk
    case jeonnam
    case gyeongbuk
    case gyeongnam
    case jeju
    
    var name: String {
        switch self {
        case .seoul: "서울특별시"
        case .busan: "부산광역시"
        case .daegu: "대구광역시"
        case .incheon: "인천광역시"
        case .gwangju: "광주광역시"
        case .daejeon: "대전광역시"
        case .ulsan: "울산광역시"
        case .sejong: "세종특별자치시"
        case .gyeonggi: "경기도"
        case .gangwon: "강원도"
        case .chungbuk: "충청북도"
        case .chungnam: "충청남도"
        case .jeonbuk: "전라북도"
        case .jeonnam: "전라남도"
        case .gyeongbuk: "경상북도"
        case .gyeongnam: "경상남도"
        case .jeju: "제주도"
        }
    }
}
