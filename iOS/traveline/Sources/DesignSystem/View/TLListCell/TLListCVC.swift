//
//  TLListCVC.swift
//  traveline
//
//  Created by 김영인 on 2023/11/17.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class TLListCVC: UICollectionViewCell {
    static let identifier = String(describing: type(of: TLListCVC.self))
    
    private let tlInfoView: TLInfoView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(item: TravelListInfo) {
        tlInfoView.setData(item: item)
    }
}

private extension TLListCVC {
    func setupLayout() {
        addSubview(tlInfoView)
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tlInfoView.topAnchor.constraint(equalTo: topAnchor),
            tlInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tlInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tlInfoView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
