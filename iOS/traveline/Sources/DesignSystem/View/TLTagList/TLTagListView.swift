//
//  TLTagListView.swift
//  traveline
//
//  Created by 김태현 on 11/21/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class TLTagListView: UIView {
    
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
    
    private let tagStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = Metric.tagSpacing
        stackView.distribution = .fill
        stackView.alignment = .center
        
        return stackView
    }()
    
    // MARK: - Properties
    
    private let tagType: TagType
    private var detailTagList: [TLTag] = .init()
    private lazy var currentStackView: UIStackView = tagStackView
    
    private var currentWidth: CGFloat = 0
    private let limitWidth: CGFloat
    
    // MARK: - Initializer
    
    init(tagType: TagType, width: CGFloat) {
        self.tagType = tagType
        self.limitWidth = width
        
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
        setupTags()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func makeNextLine() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Metric.tagSpacing
        stackView.distribution = .fill
        stackView.alignment = .center
        
        baseStackView.addArrangedSubview(stackView)
        currentStackView = stackView
        currentWidth = 0
    }
    
    @objc private func selectTag(_ sender: TLTag) {
        sender.isSelected.toggle()
    }
    
}

// MARK: - Setup Functions

private extension TLTagListView {
    func setupAttributes() {
        backgroundColor = TLColor.black
    }
    
    func setupLayout() {
        addSubviews(baseStackView)
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        baseStackView.addArrangedSubviews(tagStackView)
        
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalTo: topAnchor),
            baseStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            baseStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            baseStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupTags() {
        tagType.detailTags.forEach { detailTag in
            let tlTag: TLTag = .init(
                style: .selectable,
                name: detailTag,
                color: tagType.color
            )
            let neededWidth: CGFloat = tlTag.intrinsicContentSize.width + Metric.tagSpacing
            
            if currentWidth + neededWidth > limitWidth {
                makeNextLine()
            }
            
            tlTag.addTarget(self, action: #selector(selectTag(_:)), for: .touchUpInside)
            detailTagList.append(tlTag)
            currentStackView.addArrangedSubview(tlTag)
            currentWidth += neededWidth
        }
    }
}

@available(iOS 17, *)
#Preview {
    TLTagListView(tagType: .theme, width: 361)
}
