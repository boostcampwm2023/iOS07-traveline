//
//  TLFloatingButton.swift
//  traveline
//
//  Created by 김태현 on 11/21/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

import Core

final class TLFloatingButton: UIButton {
    
    // MARK: - UI Components
    
    private let innerView: UIView = {
        let view = UIView()
        
        view.isUserInteractionEnabled = false
        view.backgroundColor = TLColor.main
        
        return view
    }()
    
    private let floatingImageView: UIImageView = .init()
    
    // MARK: - Properties
    
    override var isHighlighted: Bool {
        didSet {
            innerView.backgroundColor = isHighlighted ? TLColor.pressedMain : TLColor.main
        }
    }
    
    private let style: TLFloatingButtonStyle
    
    // MARK: - Initializer
    
    init(style: TLFloatingButtonStyle) {
        self.style = style
        
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Setup Functions

private extension TLFloatingButton {
    func setupAttributes() {
        floatingImageView.image = style.floatingImage
        layer.masksToBounds = false
        innerView.layer.cornerRadius = style.height / 2
        innerView.addShadow(
            xOffset: 0,
            yOffset: 2,
            blur: 8,
            color: TLColor.black,
            alpha: 0.25
        )
    }
    
    func setupLayout() {
        addSubviews(innerView)
        innerView.addSubviews(floatingImageView)
        [innerView, floatingImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            innerView.topAnchor.constraint(equalTo: topAnchor),
            innerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            innerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            innerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            innerView.heightAnchor.constraint(equalToConstant: style.height),
            innerView.widthAnchor.constraint(equalTo: innerView.heightAnchor),
            
            floatingImageView.centerXAnchor.constraint(equalTo: innerView.centerXAnchor),
            floatingImageView.centerYAnchor.constraint(equalTo: innerView.centerYAnchor),
            floatingImageView.heightAnchor.constraint(equalToConstant: 24.0),
            floatingImageView.widthAnchor.constraint(equalTo: floatingImageView.heightAnchor)
        ])
    }
}

@available(iOS 17, *)
#Preview {
    TLFloatingButton(style: .create)
}
