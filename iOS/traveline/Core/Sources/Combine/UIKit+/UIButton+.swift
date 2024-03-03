//
//  UIButton+.swift
//  traveline
//
//  Created by 김영인 on 2023/11/27.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

extension UIButton {
    public var tapPublisher: EventPublisher {
        publisher(for: .touchUpInside)
    }
}
