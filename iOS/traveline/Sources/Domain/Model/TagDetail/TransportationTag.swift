//
//  TransportationTag.swift
//  traveline
//
//  Created by 김태현 on 11/21/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum TransportationTag: DetailTagType {
    case publicTransport
    case drive
    
    init?(title: String) {
        switch title {
        case .publicTransport:
            self = .publicTransport
        case .drive:
            self = .drive
        default:
            return nil
        }
    }
    
    static func ~= (lhs: Self, rhs: String) -> Bool {
        return lhs.title == rhs
    }
    
    var title: String {
        switch self {
        case .publicTransport:
            Literal.Tag.TransportationDetail.publicTransport
        case .drive:
            Literal.Tag.TransportationDetail.drive
        }
    }
    
    var query: String {
        switch self {
        case .publicTransport:
            Literal.Tag.TransportationDetail.publicTransport
        case .drive:
            Literal.Tag.TransportationDetail.drive
        }
    }
}
