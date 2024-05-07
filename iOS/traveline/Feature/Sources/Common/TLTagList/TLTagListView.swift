//
//  TLTagListView.swift
//  traveline
//
//  Created by 김태현 on 11/21/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

import Core
import DesignSystem
import Domain

/*
 여행 생성 화면에서 태그 제목 및 태그 버튼들을 가지는 뷰입니다.
 ----
 인원
 [1인] [2인] [3인] [4인] [5인 이상]
 */

extension TagType {
    var color: DesignSystemColors.Color {
        switch self {
        case .region:
            TLColor.Tag.region
        case .period:
            TLColor.Tag.period
        case .season:
            TLColor.Tag.season
        case .theme:
            TLColor.Tag.theme
        case .cost:
            TLColor.Tag.cost
        case .people:
            TLColor.Tag.people
        case .with:
            TLColor.Tag.with
        case .transportation:
            TLColor.Tag.transportation
        }
    }
}

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
    
    private var detailTagList: [TLTag] = []
    private lazy var currentStackView: UIStackView = tagStackView
    private var tagType: TagType?
    private var selectedTag: TLTag?

    private var currentWidth: CGFloat = 0
    private let limitWidth: CGFloat
    
    var selectedTags: [String] {
        detailTagList.filter({ $0.isSelected }).map { $0.name }
    }
    
    // MARK: - Initializer
    
    init(tagType: TagType, width: CGFloat) {
        self.limitWidth = width
        self.tagType = tagType
        
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
        setupTags()
    }
    
    init(width: CGFloat) {
        self.limitWidth = width
        
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
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
        if let tagType, !tagType.isMultiple, selectedTag != sender {
            selectedTag?.isSelected = false
            selectedTag = sender
        }
        sender.isSelected.toggle()
    }
    
    /// TLTagListView 생성 후 Tag를 추가할 때
    func setTags(_ tags: [Tag], style: TLTagStyle) {
        tags.forEach { tag in
            let tlTag: TLTag = .init(
                style: style,
                name: tag.title,
                color: tag.type.color
            )
            let neededWidth: CGFloat = tlTag.intrinsicContentSize.width + Metric.tagSpacing
            
            if currentWidth + neededWidth > limitWidth {
                makeNextLine()
            }
            
            currentStackView.addArrangedSubview(tlTag)
            currentWidth += neededWidth
        }
    }
    
    /// TLTagListView를 Cell에서 재사용 시 초기화
    func resetTags() {
        currentWidth = 0
        currentStackView = tagStackView
        baseStackView
            .arrangedSubviews
            .filter({ $0 != tagStackView })
            .forEach {
                $0.removeFromSuperview()
            }
        
        tagStackView
            .arrangedSubviews
            .forEach {
                $0.removeFromSuperview()
            }
    }
    
    func setSelectedTag(_ name: String) {
        detailTagList.filter { $0.name == name }.forEach {
            $0.isSelected.toggle()
            selectedTag = $0
        }
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
        guard let tagType else { return }
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
