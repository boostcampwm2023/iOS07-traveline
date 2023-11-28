//
//  UITextField+.swift
//  traveline
//
//  Created by 김영인 on 2023/11/27.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import UIKit

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        publisher(for: .editingChanged)
            .compactMap { self.text }
            .eraseToAnyPublisher()
    }
}
