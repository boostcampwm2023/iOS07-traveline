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
    public class EventSubscription<S: Subscriber>: Subscription where S.Input == Void {
        
        public var subscriber: S?
        
        public func request(_ demand: Subscribers.Demand) { }
        
        public func cancel() {
            subscriber = nil
        }
        
        @objc public func trigger() {
            _ = subscriber?.receive(Void())
        }
    }
}
