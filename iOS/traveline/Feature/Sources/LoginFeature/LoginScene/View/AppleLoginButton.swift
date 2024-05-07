//
//  AppleLoginButton.swift
//  traveline
//
//  Created by 김영인 on 2023/11/28.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

import DesignSystem

final class AppleLoginButton: UIButton {
    
    private enum Metric {
        static let size: CGFloat = 20
        static let cornerRadius: CGFloat = 12
        static let spacing: CGFloat = 15
    }
    
    private enum Constants {
        static let appleLogo: String = "apple.logo"
        static let appleLogin: String = "Apple로 계속하기"
    }
    
    // MARK: - UI Components
    
    private let innerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.backgroundColor = .clear
        stackView.spacing = Metric.spacing
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    private let appleLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: Constants.appleLogo)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = TLColor.black
        return imageView
    }()
    
    private let appleLoginLabel: TLLabel = .init(
        font: .subtitle2,
        text: Constants.appleLogin,
        color: TLColor.black
    )
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? TLColor.pressedWhite : TLColor.white
        }
    }
    
    // MARK: - Initialzier
    
    init() {
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup Functions

private extension AppleLoginButton {
    func setupAttributes() {
        backgroundColor = TLColor.white
        layer.cornerRadius = Metric.cornerRadius
        clipsToBounds = true
    }
    
    func setupLayout() {
        addSubview(innerStackView)
        innerStackView.addArrangedSubviews(appleLogo, appleLoginLabel)
        
        innerStackView.translatesAutoresizingMaskIntoConstraints = false
        innerStackView.arrangedSubviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            innerStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            innerStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            appleLogo.widthAnchor.constraint(equalToConstant: Metric.size)
        ])
    }
}

@available(iOS 17, *)
#Preview("AppleLoginButton") {
    let button = AppleLoginButton()
    button.widthAnchor.constraint(equalToConstant: 300).isActive = true
    return button
}
