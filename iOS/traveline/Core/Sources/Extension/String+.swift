//
//  String+.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

extension String {
    
    /// 문자열에서 해당 단어의 범위를 반환합니다.
    /// - Parameter searchString: 찾을 단어
    /// - Returns: 공통 부분의 범위
    public func findCommonWordRange(_ searchString: String) -> NSRange {
        guard let range = self.lowercased().range(of: searchString.lowercased()) else { return .init() }
        
        return NSRange(range, in: self)
    }
    
    /// 문자열을 UTF-8 인코딩으로 변환하여 해당 인코딩된 데이터를 반환합니다.
    ///
    /// - Returns: UTF-8로 인코딩된 데이터
    public func toUTF8() -> Data {
        self.data(using: .utf8) ?? Data()
    }
    
    /// 문자열을 원하는 날짜 및 시간 형식으로 변환합니다.
    /// - Parameters:
    ///   - type: 변환할 날짜 및 시간 형식 문자열
    /// - Returns: 변환된 날짜 및 시간 문자열. 변환에 실패하면 "00:00"을 반환합니다.
    public func convertTimeFormat(from fromFormat: String, to toFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = fromFormat
        
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: date)
    }
    
    /// 문자열을 "yyyy-MM-dd" 형식의 날짜로 변환합니다.
    ///
    /// - Returns: 변환된 날짜. 변환에 실패하면 nil을 반환합니다.
    public func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.date(from: self)
    }
    
    /// 문자열을 Double로 변환합니다.
    ///
    /// - Returns: 변환된 Double 값. 변환에 실패하면 0을 반환합니다.
    public func toDouble() -> Double {
        return Double(self) ?? 0.0
    }
}
