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
    
    /// 문자열에서 해당 단어의 범위를 반환합니다.
    /// - Parameter searchString: 찾을 단어
    /// - Returns: 공통 부분의 범위
    func findCommonWordRange(_ searchString: String) -> NSRange {
        guard let range = self.range(of: searchString) else { return .init() }
        
        return NSRange(range, in: self)
    }
    
}
