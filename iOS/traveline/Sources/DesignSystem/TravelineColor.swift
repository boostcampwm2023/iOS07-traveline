//
//  TravelineColor.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/14.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum TravelineColor {
    static let main = TravelineAsset.main.color
    static let lightMain = TravelineAsset.lightMain.color
    static let black = TravelineAsset.black.color
    static let gray = TravelineAsset.gray.color
    static let lightGray = TravelineAsset.lightGray.color
    static let white = TravelineAsset.white.color
    static let backgroundGray = TravelineAsset.backgroundGray.color
    static let lineGray = TravelineAsset.lineGray.color
    static let dimmed = TravelineAsset.dimmed.color
    static let success = TravelineAsset.success.color
    static let warning = TravelineAsset.warning.color
    static let error = TravelineAsset.error.color
    
    enum Tag {
        static let location = TravelineAsset.locaction.color
        static let cost = TravelineAsset.cost.color
        static let period = TravelineAsset.period.color
        static let people = TravelineAsset.people.color
        static let transportation = TravelineAsset.transportation.color
        static let theme = TravelineAsset.theme.color
        static let with = TravelineAsset.with.color
        static let season = TravelineAsset.season.color
    }
}
