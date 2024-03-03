//
//  TLColor.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/14.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum TLColor {
    static let main = TravelineAsset.Colors.main.color
    static let lightMain = TravelineAsset.Colors.lightMain.color
    static let pressedMain = TravelineAsset.Colors.pressedMain.color
    static let black = TravelineAsset.Colors.black.color
    static let disabledGray = TravelineAsset.Colors.disabledGray.color
    static let unselectedGray = TravelineAsset.Colors.unSelectedGray.color
    static let darkGray = TravelineAsset.Colors.darkGray.color
    static let gray = TravelineAsset.Colors.gray.color
    static let lightGray = TravelineAsset.Colors.lightGray.color
    static let mediumGray = TravelineAsset.Colors.mediumGray.color
    static let white = TravelineAsset.Colors.white.color
    static let pressedWhite = TravelineAsset.Colors.pressedWhite.color
    static let backgroundGray = TravelineAsset.Colors.backgroundGray.color
    static let lineGray = TravelineAsset.Colors.lineGray.color
    static let dimmed = TravelineAsset.Colors.dimmed.color
    static let success = TravelineAsset.Colors.success.color
    static let warning = TravelineAsset.Colors.warning.color
    static let error = TravelineAsset.Colors.error.color
    
    enum Tag {
        static let region = TravelineAsset.Colors.region.color
        static let cost = TravelineAsset.Colors.cost.color
        static let period = TravelineAsset.Colors.period.color
        static let people = TravelineAsset.Colors.people.color
        static let transportation = TravelineAsset.Colors.transportation.color
        static let theme = TravelineAsset.Colors.theme.color
        static let with = TravelineAsset.Colors.with.color
        static let season = TravelineAsset.Colors.season.color
    }
    
    enum Toast {
        static let success = TravelineAsset.Colors.toastSuccess.color
        static let failure = TravelineAsset.Colors.toastFailure.color
    }
}
