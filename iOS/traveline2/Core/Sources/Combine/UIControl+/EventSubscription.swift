//
//  EventSubscription.swift
//  traveline
//
//  Created by 김영인 on 2023/11/27.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import UIKit

extension UIControl {
    class EventSubscription<S: Subscriber>: Subscription where S.Input == Void {
        
        var subscriber: S?
        
        func request(_ demand: Subscribers.Demand) { }
        
        func cancel() {
            subscriber = nil
        }
        
        @objc func trigger() {
            _ = subscriber?.receive(Void())
        }
    }
}
