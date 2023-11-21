//
//  SelectTagView.swift
//  traveline
//
//  Created by 김태현 on 11/21/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class SelectTagView: UIView {
    
    private enum Metric {
        static let tagSpacing: CGFloat = 8.0
    }
    
    // MARK: - UI Components
    
    private let baseStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 12.0
        stackView.distribution = .fill
        stackView.alignment = .leading
        
        return stackView
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 4.0
        stackView.distribution = .fill
        stackView.alignment = .trailing
        
        return stackView
    }()
    
    private let tagTitleLabel = TLLabel(
        font: .subtitle2,
        color: TLColor.white
    )
    
    private let tagSubtitleLabel = TLLabel(
        font: .body4,
        color: TLColor.gray
    )
    
    private lazy var tagListView: TLTagListView = .init(tagType: tagType, width: limitWidth)
    
    // MARK: - Properties
    
    private let tagType: TagType
    private let limitWidth: CGFloat
    
    // MARK: - Initializer
    
    init(tagType: TagType, width: CGFloat) {
        self.tagType = tagType
        self.limitWidth = width
        
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Setup Functions

private extension SelectTagView {
    func setupAttributes() {
        backgroundColor = TLColor.black
        tagTitleLabel.setText(to: tagType.title)
        
        if let subtitle = tagType.subtitle {
            tagSubtitleLabel.setText(to: subtitle)
        }
    }
    
    func setupLayout() {
        addSubviews(baseStackView)
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        baseStackView.addArrangedSubviews(
            titleStackView,
            tagListView
        )
        titleStackView.addArrangedSubviews(
            tagTitleLabel,
            tagSubtitleLabel
        )
        
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalTo: topAnchor),
            baseStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            baseStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            baseStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

@available(iOS 17, *)
#Preview {
    SelectTagView(tagType: .theme, width: 361)
}
