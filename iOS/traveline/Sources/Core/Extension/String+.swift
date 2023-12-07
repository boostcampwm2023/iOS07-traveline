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
    
    /// 비교할 문자열과 공통 부분의 범위를 반환합니다.
    /// - Parameter compareString: 비교할 문자열
    /// - Returns: 공통 부분의 범위
    func findCommonPrefixRange(_ compareString: String) -> NSRange {
        let minLength = min(self.count, compareString.count)
        var commonPrefix = ""
        
        for offset in 0..<minLength {
            let index1 = self.index(self.startIndex, offsetBy: offset)
            let index2 = compareString.index(compareString.startIndex, offsetBy: offset)
            
            if self[index1] == compareString[index2] {
                commonPrefix.append(self[index1])
            } else {
                break
            }
        }
        
        return (self as NSString).range(of: commonPrefix)
    }
    
    /// 문자열을 UTF-8 인코딩으로 변환하여 해당 인코딩된 데이터를 반환합니다.
    ///
    /// - Returns: UTF-8로 인코딩된 데이터
    func toUTF8() -> Data {
        self.data(using: .utf8) ?? Data()
    }
    
}
