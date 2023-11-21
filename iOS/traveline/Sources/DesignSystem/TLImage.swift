//
//  TLImage.swift
//  traveline
//
//  Created by 김태현 on 2023/11/16.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum TLImage {
    enum Tag {
        static let close = TravelineAsset.Images.close.image
    }
    
    enum Common {
        static let likeUnselected = TravelineAsset.Images.likeUnselected.image
        static let likeSelected = TravelineAsset.Images.likeSelected.image
        static let camera = TravelineAsset.Images.camera.image
    }
    
    enum Travel {
        static let location = TravelineAsset.Images.location.image
        static let time = TravelineAsset.Images.time.image
    }
}
