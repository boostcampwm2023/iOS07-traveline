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
        static let close = DesignSystemAsset.Images.close.image
    }
    
    enum Filter {
        static let total = DesignSystemAsset.Images.totalFilter.image
        static let totalSelected = DesignSystemAsset.Images.totalFilterSelected.image
        static let down = DesignSystemAsset.Images.downArrow.image
        static let downSelected = DesignSystemAsset.Images.downArrowSelected.image
    }
    
    enum Common {
        static let like = DesignSystemAsset.Images.likeUnselected.image
        static let likeSelected = DesignSystemAsset.Images.likeSelected.image
        static let camera = DesignSystemAsset.Images.camera.image
        static let album = DesignSystemAsset.Images.album.image
        static let back = DesignSystemAsset.Images.back.image
        static let plus = DesignSystemAsset.Images.plus.image
        static let closeBlack = DesignSystemAsset.Images.closeBlack.image
        static let search = DesignSystemAsset.Images.search.image
        static let close = DesignSystemAsset.Images.closeMedium.image
        static let logo = DesignSystemAsset.Images.travelineLogo.image
        static let`default` = DesignSystemAsset.Images.default.image
        static let empty = DesignSystemAsset.Images.empty.image
        static let errorCircle = DesignSystemAsset.Images.errorCircle.image
    }
    
    enum Travel {
        static let location = DesignSystemAsset.Images.location.image
        static let locationDisable = DesignSystemAsset.Images.locationDisabled.image
        static let time = DesignSystemAsset.Images.time.image
        static let map = DesignSystemAsset.Images.map.image
        static let more = DesignSystemAsset.Images.more.image
        static let marker = DesignSystemAsset.Images.markerUnselected.image
        static let markerSelected = DesignSystemAsset.Images.markerSelected.image
    }
    
    enum Home {
        static let menu = DesignSystemAsset.Images.menu.image
    }
    
    enum ToastIcon {
        static let success = DesignSystemAsset.Images.greenFace
        static let warning = DesignSystemAsset.Images.yellowFace
        static let failure = DesignSystemAsset.Images.redFace
    }
    
}
