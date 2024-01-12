//
//  TLEmptyView.swift
//  traveline
//
//  Created by KiWoong Hong on 2024/01/12.
//  Copyright © 2024 traveline. All rights reserved.
//

import UIKit

class TLEmptyView: UIView {

    private enum Constants {
        static let emptyText: String = "아직 작성된 글이 없어요!"
        static let shareText: String = "나만의 여행 경험을 공유해보세요 :)"
    }
    
    private enum Metric {
        static let imageToLabelSpacing: CGFloat = 16
        static let labelToLabelSpacing: CGFloat = 12
        static let bottomConstants: CGFloat = UIScreen.main.bounds.width / 3 * 2
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
        let view = UIImageView(image: TLImage.Common.empty)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let emptyLabel: TLLabel = {
        let label = TLLabel(font: .subtitle2, color: TLColor.white)
        label.setText(to: Constants.emptyText)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let shareLabel: TLLabel = {
        let label = TLLabel(font: .body2, color: TLColor.white)
        label.setText(to: Constants.shareText)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - initialize
    
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

private extension TLEmptyView {
    
    func setupAttributes() {
        backgroundColor = TLColor.black
    }
    
    func setupLayout() {
        addSubview(stackView)
        stackView.addArrangedSubviews(
            imageView,
            emptyLabel,
            shareLabel
        )
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: imageView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metric.bottomConstants)
        ])
        
        stackView.setCustomSpacing(Metric.imageToLabelSpacing, after: imageView)
        stackView.setCustomSpacing(Metric.labelToLabelSpacing, after: emptyLabel)
    }
    
}
