//
//  TLTagStyle.swift
//  traveline
//
//  Created by 김태현 on 2023/11/15.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

public enum TLTagStyle {
    case normal
    case cancellable
    case selectable
}

extension TLTagStyle {
    var font: TLFont {
        switch self {
        case .normal, .cancellable:
            return .caption
        case .selectable:
            return .body2
        }
    }
    
    var height: CGFloat {
        switch self {
        case .normal, .cancellable:
            return 30.0
        case .selectable:
            return 34.0
        }
    }
    
    var horizontalInset: CGFloat {
        switch self {
        case .normal, .selectable:
            return 16.0
        case .cancellable:
            return 10.0
        }
    }
    
    var verticalInset: CGFloat {
        return 8.0
    }
}
