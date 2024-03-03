//
//  PlaceTVC.swift
//  traveline
//
//  Created by 김영인 on 2023/12/11.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class PlaceTVC: UITableViewCell {
    
    static let identifier = String(describing: type(of: PlaceTVC.self))
    
    private enum Metric {
        static let inset: CGFloat = 16
        static let spacing: CGFloat = 6
    }
    
    // MARK: - UI Components
    
    private let placeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = Metric.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: TLLabel = .init(font: .subtitle2, color: TLColor.white)
    private let subtitleLabel: TLLabel = .init(font: .body3, color: TLColor.white)
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(place: String, address: String, keyword: String) {
        titleLabel.setText(to: place)
        subtitleLabel.setText(to: address)
        titleLabel.setColor(
            to: TLColor.main,
            range: place.findCommonWordRange(keyword)
        )
    }
}

// MARK: - Setup Functions

extension PlaceTVC {
    func setupLayout() {
        placeStackView.addArrangedSubviews(titleLabel, subtitleLabel)
        
        placeStackView.arrangedSubviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addSubview(placeStackView)
        
        NSLayoutConstraint.activate([
            placeStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            placeStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.inset)
        ])
    }
}
