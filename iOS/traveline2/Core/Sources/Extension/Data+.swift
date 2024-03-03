//
//  Data+.swift
//  traveline
//
//  Created by 김영인 on 2023/12/07.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

extension Data {
    
    /// 데이터의 크기를 MB로 반환합니다.
    ///
    /// - Returns: 데이터의 크기를 MB로 표현한 값.
    func megabytes() -> Double {
        return Double(self.count / (1024 * 1024))
    }
}
