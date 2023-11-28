//
//  EventPublisher.swift
//  traveline
//
//  Created by 김영인 on 2023/11/27.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import UIKit

extension UIControl {
    struct EventPublisher: Publisher {
        
        typealias Output = Void
        typealias Failure = Never
        
        private var control: UIControl
        private var event: Event
        
        init(control: UIControl, event: Event) {
            self.control = control
            self.event = event
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Void == S.Input {
            let subscription = EventSubscription<S>()
            subscription.subscriber = subscriber
            
            subscriber.receive(subscription: subscription)
            
            control.addTarget(
                subscription,
                action: #selector(subscription.trigger),
                for: event
            )
        }
    }
}
