//
//  TravelineTag.swift
//  traveline
//
//  Created by 김태현 on 2023/11/15.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class TLTag: UIButton {
    
    enum Metric {
        static let borderWidth: CGFloat = 0.5
        static let spacing: CGFloat = 4.0
        static let cancelImageWidth: CGFloat = 12.0
    }
    
    // MARK: - UI Components
    
    private let innerView: UIView = {
        let view = UIView()
        
        view.isUserInteractionEnabled = false
        view.backgroundColor = TLColor.darkGray
        view.layer.borderWidth = Metric.borderWidth
        view.layer.borderColor = TLColor.mediumGray.cgColor
        
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = Metric.spacing
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    private let tagTitleLabel: TLLabel = TLLabel(
        font: .body2,
        text: Literal.empty,
        color: TLColor.mediumGray
    )
    
    private let cancelImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = TLImage.Tag.close
        imageView.contentMode = .scaleToFill
        imageView.isHidden = true
        
        return imageView
    }()
    
    // MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            updateTagSelected()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        var size = CGSize()
        
        size.height += style.verticalInset * 2 + tagTitleLabel.intrinsicContentSize.height
        if cancelImageView.image != nil {
            size.height += Metric.cancelImageWidth + Metric.spacing
        }
        size.width += style.horizontalInset * 2 + tagTitleLabel.intrinsicContentSize.width
        
        return size
    }
    
    private var style: TLTagStyle
    private let tagColor: UIColor
    private let defaultColor: UIColor = TLColor.mediumGray
    let name: String

    // MARK: - Initialize
    
    init(
        frame: CGRect = .zero,
        style: TLTagStyle,
        name: String,
        color: UIColor
    ) {
        self.style = style
        self.tagColor = color
        self.name = name
        tagTitleLabel.setText(to: name)
        tagTitleLabel.setFont(to: style.font)
        
        super.init(frame: frame)
        
        setupAttributes()
        setupLayout()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {        
        if style == .cancellable {
            let width = bounds.width
            let touchArea = bounds.inset(by: UIEdgeInsets(top: 0, left: width - 30, bottom: 0, right: 0))
            
            return touchArea.contains(point)
        }
        
        return super.point(inside: point, with: event)
    }
    
    // MARK: - Functions
    
    private func updateTagSelected() {
        if isSelected {
            tagTitleLabel.setColor(to: tagColor)
            innerView.layer.borderColor = tagColor.cgColor
            setupShadow()
        } else {
            tagTitleLabel.setColor(to: defaultColor)
            innerView.layer.borderColor = defaultColor.cgColor
            innerView.removeShadow()
        }
    }
    
    func updateTag(text: String) {
        tagTitleLabel.setText(to: text)
        invalidateIntrinsicContentSize()
    }
}

// MARK: - Setup Functions

private extension TLTag {
    func setupAttributes() {
        [
            innerView,
            stackView,
            tagTitleLabel,
            cancelImageView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        layer.masksToBounds = false
        innerView.layer.cornerRadius = style.height / 2
    }
    
    func setupLayout() {
        addSubview(innerView)
        innerView.addSubview(stackView)
        [tagTitleLabel, cancelImageView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            innerView.topAnchor.constraint(equalTo: topAnchor),
            innerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            innerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            innerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            innerView.heightAnchor.constraint(equalToConstant: style.height),
            
            stackView.topAnchor.constraint(equalTo: innerView.topAnchor, constant: style.verticalInset),
            stackView.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: style.horizontalInset),
            stackView.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -style.horizontalInset),
            stackView.bottomAnchor.constraint(equalTo: innerView.bottomAnchor, constant: -style.verticalInset),
            
            cancelImageView.heightAnchor.constraint(equalToConstant: Metric.cancelImageWidth),
            cancelImageView.widthAnchor.constraint(equalTo: cancelImageView.heightAnchor)
        ])
    }
    
    func setupStyle() {
        switch style {
        case .normal:
            isUserInteractionEnabled = false
            setupShadow()
        case .cancellable:
            innerView.layer.borderColor = defaultColor.cgColor
            cancelImageView.isHidden = false
            setupShadow()
        case .selectable:
            tagTitleLabel.setColor(to: defaultColor)
        }
    }
    
    func setupShadow() {
        innerView.addShadow(
            xOffset: 0,
            yOffset: 4,
            blur: 4,
            color: tagColor,
            alpha: 0.5
        )
    }
}
