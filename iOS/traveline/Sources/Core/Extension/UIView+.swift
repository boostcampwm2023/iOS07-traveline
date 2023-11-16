//
//  UIView+.swift
//  traveline
//
//  Created by 김영인 on 2023/11/15.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

extension UIView {
    func addSubViews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}
