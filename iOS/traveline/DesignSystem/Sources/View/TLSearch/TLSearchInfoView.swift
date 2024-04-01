//
//  TLSearchInfoView.swift
//  traveline
//
//  Created by 김영인 on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

import Core

public final class TLSearchInfoView: UIView {
    
    private enum Metric {
        static let spacing: CGFloat = 5
    }
    
    // MARK: - UI Components
    
    private let searchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = Metric.spacing
        return stackView
    }()
    
    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = TLImage.Common.search
        return imageView
    }()
    
    private let titleLabel: TLLabel = .init(
        font: .body1,
        color: TLColor.white
    )
    
    public let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(TLImage.Common.close, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    // MARK: - Properties
    
    public var keyword: String? {
        titleLabel.text
    }
    
    // MARK: - Initializer
    
    public init() {
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    public func setupDate(
        title: String,
        searchedKeyword: String?,
        isCloseButton: Bool,
        isSearchIcon: Bool
    ) {
        titleLabel.setText(to: title)
        closeButton.isHidden = !isCloseButton
        searchIcon.isHidden = !isSearchIcon
        
        if let searchedKeyword {
            titleLabel.setColor(
                to: TLColor.main,
                range: title.findCommonWordRange(searchedKeyword)
            )
        }
    }
}

// MARK: - Setup Functions

private extension TLSearchInfoView {
    func setupLayout() {
        searchStackView.addArrangedSubviews(searchIcon, titleLabel)
        addSubviews(searchStackView, closeButton)
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            closeButton.centerYAnchor.constraint(equalTo: searchStackView.centerYAnchor),
            
            searchStackView.topAnchor.constraint(equalTo: topAnchor),
            searchStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

