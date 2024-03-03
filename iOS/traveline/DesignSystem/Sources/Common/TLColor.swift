//
//  TLColor.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/14.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum TLColor {
    static let main = DesignSystemAsset.Colors.main.color
    static let lightMain = DesignSystemAsset.Colors.lightMain.color
    static let pressedMain = DesignSystemAsset.Colors.pressedMain.color
    static let black = DesignSystemAsset.Colors.black.color
    static let disabledGray = DesignSystemAsset.Colors.disabledGray.color
    static let unselectedGray = DesignSystemAsset.Colors.unSelectedGray.color
    static let darkGray = DesignSystemAsset.Colors.darkGray.color
    static let gray = DesignSystemAsset.Colors.gray.color
    static let lightGray = DesignSystemAsset.Colors.lightGray.color
    static let mediumGray = DesignSystemAsset.Colors.mediumGray.color
    static let white = DesignSystemAsset.Colors.white.color
    static let pressedWhite = DesignSystemAsset.Colors.pressedWhite.color
    static let backgroundGray = DesignSystemAsset.Colors.backgroundGray.color
    static let lineGray = DesignSystemAsset.Colors.lineGray.color
    static let dimmed = DesignSystemAsset.Colors.dimmed.color
    static let success = DesignSystemAsset.Colors.success.color
    static let warning = DesignSystemAsset.Colors.warning.color
    static let error = DesignSystemAsset.Colors.error.color
    
    enum Tag {
        static let region = DesignSystemAsset.Colors.region.color
        static let cost = DesignSystemAsset.Colors.cost.color
        static let period = DesignSystemAsset.Colors.period.color
        static let people = DesignSystemAsset.Colors.people.color
        static let transportation = DesignSystemAsset.Colors.transportation.color
        static let theme = DesignSystemAsset.Colors.theme.color
        static let with = DesignSystemAsset.Colors.with.color
        static let season = DesignSystemAsset.Colors.season.color
    }
    
    enum Toast {
        static let success = DesignSystemAsset.Colors.toastSuccess.color
        static let failure = DesignSystemAsset.Colors.toastFailure.color
    }
}
