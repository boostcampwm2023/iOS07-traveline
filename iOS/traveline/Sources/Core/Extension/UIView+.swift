//
//  UIView+.swift
//  traveline
//
//  Created by 김태현 on 2023/11/15.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

extension UIView {
    
    /// view에 그림자 추가
    func addShadow(
        xOffset: CGFloat,
        yOffset: CGFloat,
        blur: CGFloat,
        spread: CGFloat = 0.0,
        color: UIColor,
        alpha: Float
    ) {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: xOffset, height: yOffset)
        layer.shadowRadius = blur
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowPath = (spread == 0) ? nil : UIBezierPath(rect: bounds.insetBy(dx: -spread, dy: -spread)).cgPath
    }
    
    /// view에서 그림자 제거
    func removeShadow() {
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 0.0
        layer.shadowColor = nil
        layer.shadowOpacity = 0.0
        layer.shadowPath = nil
    }
    
}
