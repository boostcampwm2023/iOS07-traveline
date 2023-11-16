//
//  TLTagStyle.swift
//  traveline
//
//  Created by 김태현 on 2023/11/15.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum TLTagStyle {
    case normal
    case cancellable
    case selectable
}

extension TLTagStyle {
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
