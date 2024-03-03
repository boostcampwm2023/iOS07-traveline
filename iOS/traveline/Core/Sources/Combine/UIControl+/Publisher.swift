//
//  Publisher.swift
//  traveline
//
//  Created by 김영인 on 2023/11/27.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

extension UIControl {
    public func publisher(for event: Event) -> EventPublisher {
        .init(control: self, event: event)
    }
}
