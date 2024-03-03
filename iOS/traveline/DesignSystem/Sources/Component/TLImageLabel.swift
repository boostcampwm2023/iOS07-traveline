//
//  TLImageLabel.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/22.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class TLImageLabel: UIView {
    
    private enum Constants {
        static let spacing: CGFloat = 6.0
    }
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = .init()
    
    private let label: TLLabel = .init(
        font: TLFont.subtitle2,
        color: TLColor.white
    )
    
    // MARK: - Initialize
    
    init(image: UIImage? = nil, text: String = "") {
        super.init(frame: .zero)
        
        label.setText(to: text)
        imageView.image = image
        setupAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func setText(to text: String) {
        label.setText(to: text)
    }
    
    func setImage(to image: UIImage) {
        imageView.image = image
    }
    
}

// MARK: - Setup Functions

private extension TLImageLabel {
    func setupAttributes() {
        backgroundColor = .clear
    }
    
    func setupLayout() {
        addSubviews(
            imageView,
            label
        )
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.spacing),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

@available(iOS 17, *)
#Preview {
    TLImageLabel(image: TLImage.Travel.time, text: "오후 02:00")
}
