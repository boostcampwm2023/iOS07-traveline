//
//  TravelInfoCVC.swift
//  traveline
//
//  Created by 김태현 on 11/22/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

import Core
import DesignSystem
import Domain

protocol TravelInfoDelegate: AnyObject {
    func likeChanged()
}

final class TravelInfoCVC: UICollectionViewCell {
    
    private enum Metric {
        static let verticalInset: CGFloat = 16.0
        static let horizontalInset: CGFloat = 16.0
        static let likeButtonWidth: CGFloat = 34.0
        static let dateTopInset: CGFloat = 8.0
        static let tagTopInset: CGFloat = 14.0
    }
    
    // MARK: - UI Components
    
    private let travelTitleLabel: TLLabel = .init(
        font: .heading1,
        color: TLColor.white
    )
    
    private let travelDateLabel: TLLabel = .init(
        font: .body2,
        color: TLColor.gray
    )
    
    private let tagListView: TLTagListView = .init(
        width: BaseMetric.ScreenSize.width - Metric.horizontalInset * 2
    )
    
    private let likeButton: UIButton = {
        let button = UIButton()
        
        button.setImage(TLImage.Common.like, for: .normal)
        button.setImage(TLImage.Common.likeSelected, for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    // MARK: - Properties
    
    weak var delegate: TravelInfoDelegate?
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        tagListView.resetTags()
    }
    
    // MARK: - Functions
    
    func setData(from data: TimelineTravelInfo) {
        travelTitleLabel.setText(to: data.travelTitle)
        travelDateLabel.setText(to: "\(data.startDate) ~ \(data.endDate)")
        likeButton.isSelected = data.isLiked
        tagListView.setTags(data.tags, style: .normal)
    }
    
    @objc private func likeButtonPressed() {
        delegate?.likeChanged()
    }
    
}

// MARK: - Setup Functions

private extension TravelInfoCVC {
    func setupAttributes() {
        likeButton.addTarget(
            self,
            action: #selector(likeButtonPressed),
            for: .touchUpInside
        )
    }
    
    func setupLayout() {
        addSubviews(
            travelTitleLabel,
            travelDateLabel,
            tagListView,
            likeButton
        )
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            travelTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Metric.verticalInset),
            travelTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.horizontalInset),
            
            travelDateLabel.topAnchor.constraint(equalTo: travelTitleLabel.bottomAnchor, constant: Metric.dateTopInset),
            travelDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.horizontalInset),
            
            tagListView.topAnchor.constraint(equalTo: travelDateLabel.bottomAnchor, constant: Metric.tagTopInset),
            tagListView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.horizontalInset),
            tagListView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metric.horizontalInset),
            tagListView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metric.verticalInset),
            
            likeButton.topAnchor.constraint(equalTo: topAnchor, constant: Metric.verticalInset),
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metric.horizontalInset),
            likeButton.widthAnchor.constraint(equalToConstant: Metric.likeButtonWidth),
            likeButton.heightAnchor.constraint(equalTo: likeButton.widthAnchor)
        ])
    }
}
