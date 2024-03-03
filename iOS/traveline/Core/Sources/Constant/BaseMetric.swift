//
//  BaseMetric.swift
//  traveline
//
//  Created by 김영인 on 2023/11/27.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

public enum BaseMetric {
    public static let tlheight: CGFloat = 52.0
    
    public enum ScreenSize {
        public static let width: CGFloat = UIScreen.main.bounds.width
        public static let height: CGFloat = UIScreen.main.bounds.height
    }
    
    public enum Adjust {
        public static let width: CGFloat = ScreenSize.width / 375
        public static let height: CGFloat = ScreenSize.height / 812
    }
}
