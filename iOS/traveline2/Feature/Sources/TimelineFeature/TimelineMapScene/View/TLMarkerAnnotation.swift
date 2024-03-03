//
//  TLMarkerAnnotation.swift
//  traveline
//
//  Created by 김태현 on 11/23/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import MapKit
import UIKit

final class TLMarkerAnnotation: NSObject, MKAnnotation {
    
    let cardInfo: TimelineCardInfo

    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    init(cardInfo: TimelineCardInfo, coordinate: CLLocationCoordinate2D) {
        self.cardInfo = cardInfo
        self.coordinate = coordinate
    }
    
}
