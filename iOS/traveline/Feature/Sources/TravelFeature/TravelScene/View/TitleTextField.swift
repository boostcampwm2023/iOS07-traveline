//
//  TitleTextField.swift
//  traveline
//
//  Created by 김태현 on 2023/11/19.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

import Core
import DesignSystem

final class TitleTextField: UITextField {
    
    // MARK: - UI Components
    
    private let border: UIView = {
        let view = UIView()
        
        view.backgroundColor = TLColor.backgroundGray
        
        return view
    }()
    
    // MARK: - Properties
    
    override var placeholder: String? {
        didSet {
            setupPlaceholder()
        }
    }
    
    private let textPadding = UIEdgeInsets(
        top: 0,
        left: 0,
        bottom: 12,
        right: 0
    )
    
    // MARK: - Initialize
    
    init() {
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
}

// MARK: - Setup Functions

private extension TitleTextField {
    func setupAttributes() {
        setupPlaceholder()
        
        defaultTextAttributes = [
            .foregroundColor: TLColor.white,
            .font: TLFont.heading1.font
        ]
    }
    
    func setupPlaceholder() {
        attributedPlaceholder = NSMutableAttributedString(
            string: placeholder ?? Literal.empty,
            attributes: [
                .foregroundColor: TLColor.disabledGray,
                .font: TLFont.heading1.font
            ]
        )
    }
    
    func setupLayout() {
        addSubviews(border)
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            border.bottomAnchor.constraint(equalTo: bottomAnchor),
            border.leadingAnchor.constraint(equalTo: leadingAnchor),
            border.trailingAnchor.constraint(equalTo: trailingAnchor),
            border.heightAnchor.constraint(equalToConstant: 1.0)
        ])
    }
}
