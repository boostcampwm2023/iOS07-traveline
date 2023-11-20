//
//  HomeListView.swift
//  traveline
//
//  Created by 김영인 on 2023/11/15.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class HomeListView: UIView {
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeListView {
    func setupAttributes() {
        backgroundColor = TLColor.main
    }
}
