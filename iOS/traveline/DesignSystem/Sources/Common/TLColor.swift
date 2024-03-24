//
//  TLColor.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/14.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

public enum TLColor {
    public static let main = DesignSystemAsset.Colors.main.color
    public static let lightMain = DesignSystemAsset.Colors.lightMain.color
    public static let pressedMain = DesignSystemAsset.Colors.pressedMain.color
    public static let black = DesignSystemAsset.Colors.black.color
    public static let disabledGray = DesignSystemAsset.Colors.disabledGray.color
    public static let unselectedGray = DesignSystemAsset.Colors.unSelectedGray.color
    public static let darkGray = DesignSystemAsset.Colors.darkGray.color
    public static let gray = DesignSystemAsset.Colors.gray.color
    public static let lightGray = DesignSystemAsset.Colors.lightGray.color
    public static let mediumGray = DesignSystemAsset.Colors.mediumGray.color
    public static let white = DesignSystemAsset.Colors.white.color
    public static let pressedWhite = DesignSystemAsset.Colors.pressedWhite.color
    public static let backgroundGray = DesignSystemAsset.Colors.backgroundGray.color
    public static let lineGray = DesignSystemAsset.Colors.lineGray.color
    public static let dimmed = DesignSystemAsset.Colors.dimmed.color
    public static let success = DesignSystemAsset.Colors.success.color
    public static let warning = DesignSystemAsset.Colors.warning.color
    public static let error = DesignSystemAsset.Colors.error.color
    
    public enum Tag {
        public static let region = DesignSystemAsset.Colors.region.color
        public static let cost = DesignSystemAsset.Colors.cost.color
        public static let period = DesignSystemAsset.Colors.period.color
        public static let people = DesignSystemAsset.Colors.people.color
        public static let transportation = DesignSystemAsset.Colors.transportation.color
        public static let theme = DesignSystemAsset.Colors.theme.color
        public static let with = DesignSystemAsset.Colors.with.color
        public static let season = DesignSystemAsset.Colors.season.color
    }
    
    public enum Toast {
        public static let success = DesignSystemAsset.Colors.toastSuccess.color
        public static let failure = DesignSystemAsset.Colors.toastFailure.color
    }
}
