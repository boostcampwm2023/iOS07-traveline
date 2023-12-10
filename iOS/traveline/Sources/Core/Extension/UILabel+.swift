//
//  UILabel+.swift
//  traveline
//
//  Created by 김영인 on 2023/12/07.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

extension UILabel {
    func setColor(to color: UIColor, range: NSRange) {
        guard let mutableAttributedText = attributedText?.mutableCopy() as? NSMutableAttributedString else { return }
        
        mutableAttributedText.addAttribute(
            .foregroundColor,
            value: TLColor.main,
            range: range
        )
        
        attributedText = mutableAttributedText
    }
}
