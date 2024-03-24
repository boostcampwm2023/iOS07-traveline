//
//  DateIndicatorCVC.swift
//  traveline
//
//  Created by 김태현 on 11/22/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

import DesignSystem

final class DateIndicatorCVC: UICollectionViewCell {
    
    private enum Metric {
        static let topInset: CGFloat = 8.0
        static let horizontalInset: CGFloat = 12.0
        
        enum Indicator {
            static let topInset: CGFloat = 4.0
            static let horizontalInset: CGFloat = 10.0
            static let height: CGFloat = 2.0
        }
    }
    
    // MARK: - UI Components
    
    private let dateLabel: TLLabel = .init(
        font: .subtitle2,
        color: TLColor.gray
    )
    
    private let dateIndicatorView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .clear
        
        return view
    }()
    
    // MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            updateSelected()
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
    
    func setDate(_ date: String) {
        dateLabel.setText(to: date)
    }
    
    private func updateSelected() {
        dateLabel.setColor(to: isSelected ? TLColor.main : TLColor.gray)
        dateIndicatorView.backgroundColor = isSelected ? TLColor.main : .clear
    }
    
}

// MARK: - Setup Functions

private extension DateIndicatorCVC {
    func setupLayout() {
        addSubviews(dateLabel, dateIndicatorView)
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: Metric.topInset),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.horizontalInset),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metric.horizontalInset),
            
            dateIndicatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dateIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.Indicator.horizontalInset),
            dateIndicatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metric.Indicator.horizontalInset),
            dateIndicatorView.heightAnchor.constraint(equalToConstant: Metric.Indicator.height)
        ])
    }
}
