//
//  TLInfoView.swift
//  traveline
//
//  Created by 김영인 on 2023/11/17.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class TLInfoView: UIView {
    
    private enum Metric {
        static let infoInset: CGFloat = 7
        static let radius: CGFloat = 12
        static let padding: CGFloat = 12
        static let likePadding: CGFloat = 16
        static let imageSize: CGFloat = 116
        static let likeImageSize: CGFloat = 20
        static let profileImageSize: CGFloat = 20
    }
    
    private enum Constants {
        static let countZero: String = "0"
    }
    
    // MARK: - UI Components
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = TLColor.gray
        imageView.layer.cornerRadius = Metric.radius
        // TODO: - 서버 연동 후 수정
        imageView.image = TravelineAsset.Images.travelImage.image
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = TLColor.gray
        imageView.layer.cornerRadius = Metric.profileImageSize / 2
        return imageView
    }()
    
    private let nameLabel: TLLabel = .init(
        font: .body3,
        color: TLColor.gray
    )
    
    private let likeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private let likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = TLImage.Common.like
        return imageView
    }()
    
    private let likeCountLabel: TLLabel = .init(
        font: .toolTip,
        text: Constants.countZero,
        color: TLColor.gray
    )
    
    private let titleLabel: TLLabel = .init(
        font: .subtitle2,
        color: TLColor.white
    )
    
    private let tagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        return stackView
    }()
    
    private let regionTag: TLTag = .init(style: .normal, name: "", color: TagType.region.color)
    private let periodTag: TLTag = .init(style: .normal, name: "", color: TagType.period.color)
    private let seasonTag: TLTag = .init(style: .normal, name: "", color: TagType.season.color)
    private lazy var tags: [TLTag] = [regionTag, periodTag, seasonTag]
    
    // MARK: - Initialzier
    
    init() {
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Functions
    
    func setupData(item: TravelListInfo) {
        thumbnailImageView.setImage(from: item.imageURL)
        profileImageView.setImage(from: item.profile.imageURL)
        nameLabel.setText(to: item.profile.name)
        likeCountLabel.setText(to: "\(item.like)")
        titleLabel.setText(to: item.title)
        zip(tags, item.tags).forEach { tagView, tagModel in
            tagView.updateTag(text: tagModel.title)
        }
    }
    
    /// View 재사용 시 reset
    func reset() {
        thumbnailImageView.cancel()
        thumbnailImageView.image = TravelineAsset.Images.travelImage.image
        profileImageView.cancel()
        profileImageView.image = nil
    }
}

// MARK: - Setup Functions

private extension TLInfoView {
    func setupAttributes() {
        backgroundColor = TLColor.darkGray
        layer.cornerRadius = Metric.radius
    }
    
    func setupLayout() {
        profileStackView.addArrangedSubviews(profileImageView, nameLabel)
        likeStackView.addArrangedSubviews(likeImageView, likeCountLabel)
        tagStackView.addArrangedSubviews(regionTag, periodTag, seasonTag)
        
        addSubviews(
            thumbnailImageView,
            profileStackView,
            likeStackView,
            titleLabel,
            tagStackView
        )
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.padding),
            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: Metric.padding),
            thumbnailImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metric.padding),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: Metric.imageSize),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: Metric.imageSize),
            
            profileImageView.widthAnchor.constraint(equalToConstant: Metric.profileImageSize),
            profileImageView.heightAnchor.constraint(equalToConstant: Metric.profileImageSize),
            
            profileStackView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: Metric.padding),
            profileStackView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor, constant: Metric.infoInset),
            
            likeImageView.widthAnchor.constraint(equalToConstant: Metric.likeImageSize),
            likeImageView.heightAnchor.constraint(equalToConstant: Metric.likeImageSize),
            likeStackView.topAnchor.constraint(equalTo: profileStackView.topAnchor),
            likeStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metric.likePadding),
            
            titleLabel.topAnchor.constraint(equalTo: profileStackView.bottomAnchor, constant: Metric.infoInset),
            titleLabel.leadingAnchor.constraint(equalTo: profileStackView.leadingAnchor),
            
            tagStackView.leadingAnchor.constraint(equalTo: profileStackView.leadingAnchor),
            tagStackView.bottomAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: -Metric.infoInset)
        ])
    }
}

@available(iOS 17, *)
#Preview("TLInfoView") {
    let tlInfoView = TLInfoView()
    tlInfoView.setupData(item: TravelListSample.makeInfo())
    return tlInfoView
}
