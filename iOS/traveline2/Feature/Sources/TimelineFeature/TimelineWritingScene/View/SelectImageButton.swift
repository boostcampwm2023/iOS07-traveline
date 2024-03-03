//
//  SelectImageButton.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/22.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class SelectImageButton: UIView {
    
    private enum Metric {
        static let viewWidth: CGFloat = 90
        static let buttonWidth: CGFloat = 24
        static let buttonOffset: CGFloat = 9
        static let iconWidth: CGFloat = 30
        static let iconSpacing: CGFloat = 20
        static let cornerRadius: CGFloat = 12
    }
    
    // MARK: - UI Components
    
    private let view: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Metric.cornerRadius
        view.clipsToBounds = true
        
        return view
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(TLImage.Common.closeBlack, for: .normal)
        button.tintColor = TLColor.white
        button.layer.cornerRadius = Metric.cornerRadius
        button.backgroundColor = TLColor.white
        
        return button
    }()
    
    let imageView: UIImageView = .init()
    
    private let selectView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fillProportionally
        view.spacing = -4
        
        return view
    }()
    
    private let selectViewIcon: UIImageView = {
        let view = UIImageView(image: TLImage.Common.album)
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private let selectViewLabel: TLLabel = {
        let label = TLLabel(font: TLFont.body2, color: TLColor.white)
        label.textAlignment = .center
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
    
    // MARK: - Functions
    
    private func updateView(hasImage: Bool) {
        selectView.isHidden = hasImage
        imageView.isHidden = !hasImage
        cancelButton.isHidden = !hasImage
    }
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
        updateView(hasImage: image != nil)
    }
    
    func setImage(urlString: String?, imagePath: String? = nil) {
        imageView.setImage(from: urlString, imagePath: imagePath)
        updateView(hasImage: urlString != nil)
    }
    
}

// MARK: - Setup Functions

private extension SelectImageButton {
    
    func setupAttributes() {
        selectViewLabel.setText(to: "선택")
        view.backgroundColor = TLColor.backgroundGray
        updateView(hasImage: false)
    }
    
    func setupLayout() {
        addSubviews(
            view,
            cancelButton
        )
        view.addSubviews(
            imageView,
            selectView
        )
        selectView.addArrangedSubviews(
            selectViewIcon,
            selectViewLabel
        )
        
        view.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        selectView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: Metric.viewWidth),
            view.heightAnchor.constraint(equalToConstant: Metric.viewWidth),
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            cancelButton.widthAnchor.constraint(equalToConstant: Metric.buttonWidth),
            cancelButton.heightAnchor.constraint(equalToConstant: Metric.buttonWidth),
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: -Metric.buttonOffset),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.buttonOffset),
            
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            selectView.topAnchor.constraint(equalTo: view.topAnchor),
            selectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            selectViewIcon.topAnchor.constraint(equalTo: selectView.topAnchor, constant: Metric.iconSpacing),
            selectViewIcon.widthAnchor.constraint(equalToConstant: Metric.iconWidth),
            selectViewIcon.heightAnchor.constraint(equalToConstant: Metric.iconWidth),
            selectViewIcon.centerXAnchor.constraint(equalTo: selectView.centerXAnchor),
            selectViewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
