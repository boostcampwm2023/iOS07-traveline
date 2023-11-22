//
//  TLFloatingButtonStyle.swift
//  traveline
//
//  Created by 김태현 on 11/21/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum TLFloatingButtonStyle {
    case create
    
    var height: CGFloat {
        48.0
    }
    
    var floatingImage: TravelineImages.Image {
        TLImage.Common.plus
    }
}
