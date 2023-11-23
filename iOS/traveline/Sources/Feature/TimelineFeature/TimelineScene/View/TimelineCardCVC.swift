//
//  TimelineCardCVC.swift
//  traveline
//
//  Created by 김태현 on 11/23/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class TimelineCardCVC: UICollectionViewCell {
    
    private enum Metric {
        static let ballHeight: CGFloat = 16.0
        static let ballLeadingInset: CGFloat = 22.0
        static let lineWidth: CGFloat = 2.0
        static let horizontalInset: CGFloat = 16.0
        static let spacing: CGFloat = 8.0
        static let cardTopInset: CGFloat = 12.0
    }
    
    // MARK: - UI Components
    
    private let timeBallView: UIView = {
        let view = UIView()
        
        view.backgroundColor = TLColor.gray
        view.layer.cornerRadius = Metric.ballHeight / 2
        
        return view
    }()
    
    private let timeLabel: TLLabel = .init(
        font: .body2,
        color: TLColor.disabledGray
    )
    
    private let lineView: UIView = {
        let view = UIView()
        
        view.backgroundColor = TLColor.gray
        
        return view
    }()
    
    private let cardView: TimelineCardView = .init()
    
    // MARK: - Properties
    
    private lazy var lineHeightConstraint: NSLayoutConstraint = lineView.bottomAnchor.constraint(equalTo: bottomAnchor)
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func setData(by cardInfo: TimelineCardInfo) {
        cardView.setData(cardInfo: cardInfo)
        timeLabel.setText(to: "14:05")
    }
    
    /// 마지막 셀일 때 line 길이 수정
    private func changeToLast() {
        lineHeightConstraint.isActive = false
        lineView.bottomAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
    }
}

// MARK: - Setup Functions

private extension TimelineCardCVC {
    func setupLayout() {
        addSubviews(
            timeBallView,
            timeLabel,
            lineView,
            cardView
        )
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            timeBallView.topAnchor.constraint(equalTo: topAnchor),
            timeBallView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.ballLeadingInset),
            timeBallView.heightAnchor.constraint(equalToConstant: Metric.ballHeight),
            timeBallView.widthAnchor.constraint(equalTo: timeBallView.heightAnchor),
            
            timeLabel.centerYAnchor.constraint(equalTo: timeBallView.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: timeBallView.trailingAnchor, constant: Metric.spacing),
            
            lineView.topAnchor.constraint(equalTo: timeBallView.centerYAnchor),
            lineView.centerXAnchor.constraint(equalTo: timeBallView.centerXAnchor),
            lineView.widthAnchor.constraint(equalToConstant: Metric.lineWidth),
            lineHeightConstraint,
            
            cardView.topAnchor.constraint(equalTo: timeBallView.bottomAnchor, constant: Metric.cardTopInset),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.horizontalInset),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metric.horizontalInset),
        ])
    }
}

@available(iOS 17, *)
#Preview {
    let view = TimelineCardCVC()
    return view
}
