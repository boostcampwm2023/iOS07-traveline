//
//  SearchCVC.swift
//  traveline
//
//  Created by 김영인 on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class SearchCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let tlSearchInfoView: TLSearchInfoView = .init()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func setupData(item: SearchKeyword) {
        tlSearchInfoView.setupData(item: item)
    }
}

// MARK: - Setup Functions

private extension SearchCVC {
    func setupLayout() {
        addSubview(tlSearchInfoView)
        tlSearchInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tlSearchInfoView.topAnchor.constraint(equalTo: topAnchor),
            tlSearchInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tlSearchInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tlSearchInfoView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
