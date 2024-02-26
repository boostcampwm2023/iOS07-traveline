//
//  TLEmptyView.swift
//  traveline
//
//  Created by KiWoong Hong on 2024/01/12.
//  Copyright © 2024 traveline. All rights reserved.
//

import UIKit

class TLEmptyView: UIView {

    enum EmptyViewType {
        case search
        case timeline
        
        var image: UIImage {
            switch self {
            case .search:
                return TLImage.Common.errorCircle
            case .timeline:
                return TLImage.Common.empty
            }
        }
        
        var firstText: String {
            switch self {
            case .search:
                return "검색 결과가 없어요!"
            case .timeline:
                return "아직 작성된 글이 없어요!"
            }
        }
        
        var secondText: String {
            switch self {
            case .search:
                return "다른 키워드로 검색해보세요 :)"
            case .timeline:
                return "나만의 여행 경험을 공유해보세요 :)"
            }
        }
        
        var bottomConstants: CGFloat {
            switch self {
            case .search:
                return UIScreen.main.bounds.width
            case .timeline:
                return UIScreen.main.bounds.width / 3 * 2
            }
        }
    }
    
    private enum Metric {
        static let imageToLabelSpacing: CGFloat = 16
        static let labelToLabelSpacing: CGFloat = 12
    }
    
    // MARK: - UI Components
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let firstLabel: TLLabel = {
        let label = TLLabel(font: .subtitle2, color: TLColor.white)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let secondLabel: TLLabel = {
        let label = TLLabel(font: .body2, color: TLColor.white)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - properties
    
    private let emptyViewType: EmptyViewType
    
    // MARK: - initialize
    
    init(type: EmptyViewType) {
        self.emptyViewType = type
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Setup Functions

private extension TLEmptyView {
    
    func setupAttributes() {
        backgroundColor = TLColor.black
        imageView.image = emptyViewType.image
        firstLabel.setText(to: emptyViewType.firstText)
        secondLabel.setText(to: emptyViewType.secondText)
    }
    
    func setupLayout() {
        addSubview(stackView)
        stackView.addArrangedSubviews(
            imageView,
            firstLabel,
            secondLabel
        )
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: imageView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -emptyViewType.bottomConstants)
        ])
        
        stackView.setCustomSpacing(Metric.imageToLabelSpacing, after: imageView)
        stackView.setCustomSpacing(Metric.labelToLabelSpacing, after: firstLabel)
    }
    
}
