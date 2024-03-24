//
//  RegionCVC.swift
//  traveline
//
//  Created by 김태현 on 11/25/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

import DesignSystem

final class RegionCVC: UICollectionViewCell {
    
    private enum Metric {
        static let verticalInset: CGFloat = 14.0
        static let horizontalInset: CGFloat = 16.0
    }
    
    // MARK: - UI Components
    
    private let regionLabel: TLLabel = .init(font: .body1, color: TLColor.white)
    
    // MARK: - Properties
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? TLColor.pressedMain.withAlphaComponent(0.2) : TLColor.black
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func setRegion(_ region: String) {
        regionLabel.setText(to: region)
    }
}

// MARK: - Setup Functions

private extension RegionCVC {
    func setupLayout() {
        addSubview(regionLabel)
        regionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            regionLabel.topAnchor.constraint(equalTo: topAnchor, constant: Metric.verticalInset),
            regionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.horizontalInset),
            regionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metric.horizontalInset),
            regionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metric.verticalInset)
        ])
    }
}
