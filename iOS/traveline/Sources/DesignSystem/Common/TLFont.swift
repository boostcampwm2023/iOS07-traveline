//
//  TLFont.swift
//  traveline
//
//  Created by 김태현 on 2023/11/15.
//  Copyright © 2023 traveline. All rights reserved.
//
import UIKit

enum TLFont {
    case heading1
    case heading2
    case subtitle1
    case subtitle2
    case subtitle3
    case body1
    case body2
    case body3
    case body4
    case caption
    case toolTip
}

extension TLFont {

    var font: UIFont {
        switch self {
        case .heading1:
            return TravelineFontFamily.Pretendard.semiBold.font(size: 24.0)
        case .heading2:
            return TravelineFontFamily.Pretendard.semiBold.font(size: 20.0)
        case .subtitle1:
            return TravelineFontFamily.Pretendard.semiBold.font(size: 18.0)
        case .subtitle2:
            return TravelineFontFamily.Pretendard.semiBold.font(size: 16.0)
        case .subtitle3:
            return TravelineFontFamily.Pretendard.regular.font(size: 18.0)
        case .body1:
            return TravelineFontFamily.Pretendard.regular.font(size: 16.0)
        case .body2:
            return TravelineFontFamily.Pretendard.semiBold.font(size: 14.0)
        case .body3:
            return TravelineFontFamily.Pretendard.regular.font(size: 14.0)
        case .body4:
            return TravelineFontFamily.Pretendard.semiBold.font(size: 12.0)
        case .caption:
            return TravelineFontFamily.Pretendard.medium.font(size: 12.0)
        case .toolTip:
            return TravelineFontFamily.Pretendard.regular.font(size: 12.0)
        }
    }

    var lineHeight: CGFloat {
        switch self {
        case .heading1, .heading2, .body2, .body3:
            return 1.3
        case .subtitle1, .subtitle2, .subtitle3, .body1:
            return 1.4
        case .body4, .caption, .toolTip:
            return 1.2
        }
    }

    var letterSpacing: CGFloat {
        switch self {
        case .heading1:
            return -0.05
        case .caption:
            return -0.025
        default:
            return -0.03
        }
    }

}
