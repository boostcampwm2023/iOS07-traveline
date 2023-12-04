//
//  TLSearchInfoView.swift
//  traveline
//
//  Created by 김영인 on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class TLSearchInfoView: UIView {
    
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
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(TLImage.Common.close, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    // MARK: - Properties
    
    var keyword: String? {
        titleLabel.text
    }
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func setupData(item: SearchKeyword) {
        titleLabel.setText(to: item.title)
        closeButton.isHidden = (item.type == .related)
        searchIcon.isHidden = (item.type == .recent)
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

@available(iOS 17, *)
#Preview("TLSearchInfoView") {
    let view = TLSearchInfoView()
    view.setupData(
        item: SearchKeyword(
            type: .recent,
            title: "여행"
        )
    )
    return view
}
