//
//  String+.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

extension String {
    
    func attributeFirstLetterToMainColor() -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let length = self.count
        let range = (self as NSString).range(of: self)
        let colorRange = (self as NSString).range(of: String(self.dropLast(length - 1)))
        
        attributedString.addAttribute(
            .font,
            value: TLFont.body1.font,
            range: range
        )
        
        attributedString.addAttribute(
            .foregroundColor,
            value: TLColor.main,
            range: colorRange
        )
        
        return attributedString
    }
}
