//
//  UILabel+.swift
//  traveline
//
//  Created by 김영인 on 2023/12/07.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// 해당 범위의 색상을 변경합니다.
    /// - Parameters:
    ///   - color: 변경할 색상
    ///   - range: 변경할 범위
    public func setColor(to color: UIColor, range: NSRange) {
        guard let mutableAttributedText = attributedText?.mutableCopy() as? NSMutableAttributedString else { return }
        
        mutableAttributedText.addAttribute(
            .foregroundColor,
            value: TLColor.main,
            range: range
        )
        
        attributedText = mutableAttributedText
    }
    
}
