//
//  TimelineCardView.swift
//  traveline
//
//  Created by 김태현 on 11/23/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class TimelineCardView: UIView {
    
    private enum Metric {
        static let radius: CGFloat = 12.0
        static let horizontalInset: CGFloat = 14.0
        static let verticalInset: CGFloat = 16.0
        static let thumbnailHeight: CGFloat = 68.0
        static let labelLeadingInset: CGFloat = 18.0
        static let labelSpacing: CGFloat = 4.0
    }
    
    // MARK: - UI Components
    
    private let baseStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = Metric.labelLeadingInset
        
        return stackView
    }()
    
    private let thumbnailImageView: UIImageView = .init()
    private let contentView: UIView = .init()
    private let titleLabel: TLLabel = .init(font: .subtitle2, color: TLColor.white)
    private let subtitleLabel: TLLabel = .init(font: .body4, color: TLColor.gray)
    private let contentLabel: TLLabel = .init(font: .body2, color: TLColor.lightGray)

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions
    
    func setData(cardInfo: TimelineCardInfo) {
        titleLabel.setText(to: cardInfo.title)
        subtitleLabel.setText(to: cardInfo.subtitle)
        contentLabel.setText(to: cardInfo.content)
        thumbnailImageView.setImage(from: cardInfo.thumbnailURL)
    }
    
    /// 셀 재사용 시 이미지 reset
    func reset() {
        thumbnailImageView.cancel()
        thumbnailImageView.image = nil
    }
    
}

// MARK: - Setup Functions

private extension TimelineCardView {
    func setupAttributes() {
        backgroundColor = TLColor.darkGray
        layer.cornerRadius = Metric.radius
        thumbnailImageView.backgroundColor = TLColor.disabledGray
        thumbnailImageView.layer.cornerRadius = 12.0
        thumbnailImageView.clipsToBounds = true
    }
    
    func setupLayout() {
        addSubviews(baseStackView)
        contentView.addSubviews(
            titleLabel,
            subtitleLabel,
            contentLabel
        )
        
        baseStackView.addArrangedSubviews(thumbnailImageView, contentView)
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalTo: topAnchor, constant: Metric.verticalInset),
            baseStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.horizontalInset),
            baseStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metric.horizontalInset),
            baseStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metric.verticalInset),
            
            thumbnailImageView.heightAnchor.constraint(equalToConstant: Metric.thumbnailHeight),
            thumbnailImageView.widthAnchor.constraint(equalTo: thumbnailImageView.heightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metric.labelSpacing),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metric.verticalInset),
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

@available(iOS 17, *)
#Preview {
    let view = TimelineCardView()
    view.setData(cardInfo: TimelineSample.makeCard())
    return view
}
