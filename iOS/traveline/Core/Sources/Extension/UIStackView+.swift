//
//  UIStackView+.swift
//  traveline
//
//  Created by 김영인 on 2023/11/20.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

extension UIStackView {
    /// 여러 view를 순서대로 addArrangedSubview
    public func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
