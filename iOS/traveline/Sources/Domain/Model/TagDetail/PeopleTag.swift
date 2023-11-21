//
//  PeopleTag.swift
//  traveline
//
//  Created by 김태현 on 11/21/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum PeopleTag: DetailTagType {
    case one
    case two
    case three
    case four
    case overFive
    
    var title: String {
        switch self {
        case .one:
            Literal.Tag.PeopleDetail.one
        case .two:
            Literal.Tag.PeopleDetail.two
        case .three:
            Literal.Tag.PeopleDetail.three
        case .four:
            Literal.Tag.PeopleDetail.four
        case .overFive:
            Literal.Tag.PeopleDetail.overFive
        }
    }
}
