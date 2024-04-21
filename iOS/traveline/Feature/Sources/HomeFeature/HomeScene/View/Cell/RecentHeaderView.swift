//
//  RecentHeaderView.swift
//  traveline
//
//  Created by 김영인 on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

import Core
import DesignSystem
import Domain

final class RecentHeaderView: UICollectionReusableView {
    
    private enum Metric {
        static let inset: CGFloat = 16
    }
    
    private enum Constants {
        static let recentSearch: String = "최근 검색어"
    }
    
    // MARK: - UI Components
    
    private let titleLabel: TLLabel = .init(
        font: .body4,
        text: Constants.recentSearch,
        color: TLColor.gray
    )
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func setupText(_ type: SearchViewType) {
        titleLabel.setText(to: type == .recent ? Constants.recentSearch : Literal.empty)
    }
}

private extension RecentHeaderView {
    func setupLayout() {
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Metric.inset),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
