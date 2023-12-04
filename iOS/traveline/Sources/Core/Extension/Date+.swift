//
//  Date+.swift
//  traveline
//
//  Created by 김영인 on 2023/12/03.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

extension Date {
    
    /// Date 타입을 "yyyy-MM-dd" 형식으로 변환합니다.
    /// - Returns: 변환된 문자열
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: self)
    }
}
