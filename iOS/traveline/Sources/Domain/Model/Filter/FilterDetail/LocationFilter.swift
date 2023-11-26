//
//  LocationFilter.swift
//  traveline
//
//  Created by 김영인 on 2023/11/24.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum LocationFilter: DetailTagType {
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
    
    var title: String {
        switch self {
        case .seoul:
            return Literal.Filter.LocationDetail.seoul
        case .busan:
            return Literal.Filter.LocationDetail.busan
        case .daegu:
            return Literal.Filter.LocationDetail.daegu
        case .incheon:
            return Literal.Filter.LocationDetail.incheon
        case .gwangju:
            return Literal.Filter.LocationDetail.gwangju
        case .daejeon:
            return Literal.Filter.LocationDetail.daejeon
        case .ulsan:
            return Literal.Filter.LocationDetail.ulsan
        case .sejong:
            return Literal.Filter.LocationDetail.sejong
        case .gyeonggi:
            return Literal.Filter.LocationDetail.gyeonggi
        case .gangwon:
            return Literal.Filter.LocationDetail.gangwon
        case .chungbuk:
            return Literal.Filter.LocationDetail.chungbuk
        case .chungnam:
            return Literal.Filter.LocationDetail.chungnam
        case .jeonbuk:
            return Literal.Filter.LocationDetail.jeonbuk
        case .jeonnam:
            return Literal.Filter.LocationDetail.jeonnam
        case .gyeongbuk:
            return Literal.Filter.LocationDetail.gyeongbuk
        case .gyeongnam:
            return Literal.Filter.LocationDetail.gyeongnam
        case .jeju:
            return Literal.Filter.LocationDetail.jeju
        }
    }
}
