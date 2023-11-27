//
//  TLFilterDetailButton.swift
//  traveline
//
//  Created by 김영인 on 2023/11/24.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class TLFilterDetailButton: UIButton {
    
    private enum Metric {
        static let inset: CGFloat = 16
    }
    
    // MARK: - UI Components
    
    private let filterTitleLabel: TLLabel = .init(
        font: .body1,
        color: TLColor.white
    )
    
    // MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            updateFilterIsSelected()
        }
    }
    
    let title: String
    
    // MARK: - Initializer
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func updateFilterIsSelected() {
        backgroundColor = isSelected ? TLColor.pressedMain.withAlphaComponent(0.30) : TLColor.black
    }
}

// MARK: - Setup Functions

private extension TLFilterDetailButton {
    func setupAttributes() {
        filterTitleLabel.setText(to: title)
        backgroundColor = TLColor.black
    }
    
    func setupLayout() {
        addSubview(filterTitleLabel)
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            filterTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.inset),
            filterTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
