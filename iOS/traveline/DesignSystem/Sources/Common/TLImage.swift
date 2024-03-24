//
//  TLImage.swift
//  traveline
//
//  Created by 김태현 on 2023/11/16.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

public enum TLImage {
    
    public enum Tag {
        public static let close = DesignSystemAsset.Images.close.image
    }
    
    public enum Filter {
        public static let total = DesignSystemAsset.Images.totalFilter.image
        public static let totalSelected = DesignSystemAsset.Images.totalFilterSelected.image
        public static let down = DesignSystemAsset.Images.downArrow.image
        public static let downSelected = DesignSystemAsset.Images.downArrowSelected.image
    }
    
    public enum Common {
        public static let like = DesignSystemAsset.Images.likeUnselected.image
        public static let likeSelected = DesignSystemAsset.Images.likeSelected.image
        public static let camera = DesignSystemAsset.Images.camera.image
        public static let album = DesignSystemAsset.Images.album.image
        public static let back = DesignSystemAsset.Images.back.image
        public static let plus = DesignSystemAsset.Images.plus.image
        public static let closeBlack = DesignSystemAsset.Images.closeBlack.image
        public static let search = DesignSystemAsset.Images.search.image
        public static let close = DesignSystemAsset.Images.closeMedium.image
        public static let logo = DesignSystemAsset.Images.travelineLogo.image
        public static let`default` = DesignSystemAsset.Images.default.image
        public static let empty = DesignSystemAsset.Images.empty.image
        public static let errorCircle = DesignSystemAsset.Images.errorCircle.image
    }
    
    public enum Travel {
        public static let location = DesignSystemAsset.Images.location.image
        public static let locationDisable = DesignSystemAsset.Images.locationDisabled.image
        public static let time = DesignSystemAsset.Images.time.image
        public static let map = DesignSystemAsset.Images.map.image
        public static let more = DesignSystemAsset.Images.more.image
        public static let marker = DesignSystemAsset.Images.markerUnselected.image
        public static let markerSelected = DesignSystemAsset.Images.markerSelected.image
    }
    
    public enum Home {
        public static let menu = DesignSystemAsset.Images.menu.image
    }
    
    public enum ToastIcon {
        public static let success = DesignSystemAsset.Images.greenFace
        public static let warning = DesignSystemAsset.Images.yellowFace
        public static let failure = DesignSystemAsset.Images.redFace
    }
    
}
