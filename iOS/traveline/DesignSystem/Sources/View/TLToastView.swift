//
//  TLToast.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/09.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

import Core

public final class TLToastView: UIView {
    
    public enum ToastType: String {
        case success = "Success"
        case failure = "Failure"
        
        var color: UIColor {
            switch self {
            case .success:
                return TLColor.Toast.success
            case .failure:
                return TLColor.Toast.failure
            }
        }
    }
    
    private enum Metric {
        static let margin: CGFloat = 16.0
        static let toastHeight: CGFloat = 40.0
    }
    
    // MARK: - UI Components
    
    private let contentLabel: TLLabel = .init(font: TLFont.body2, color: TLColor.white)
    
    // MARK: - properties
    
    private let toastType: ToastType
    private var message: String
    var followsUndockedKeyboard: Bool
    
    // MARK: - initialize
    
    init(type: ToastType = .success, message: String = "", followsUndockedKeyboard: Bool = false) {
        self.toastType = type
        self.message = message
        self.followsUndockedKeyboard = followsUndockedKeyboard
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    public func setMessage(_ message: String) {
        self.message = message
        contentLabel.setText(to: message)
    }
    
    public func show(in view: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        alpha = 1.0
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(
                equalTo: followsUndockedKeyboard ? view.keyboardLayoutGuide.topAnchor : view.safeAreaLayoutGuide.bottomAnchor,
                constant: -8
            ),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.margin),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.margin),
            heightAnchor.constraint(equalToConstant: Metric.toastHeight)
        ])
        UIView.animate(
            withDuration: 1.0,
            delay: 1.5,
            animations: {
                self.alpha = 0.0
            },
            completion: { [weak self] _ in
                self?.removeFromSuperview()
            })
    }
}

// MARK: - Setup Functions

private extension TLToastView {
    
    func setupAttributes() {
        contentLabel.setText(to: message)
        
        backgroundColor = toastType.color
        layer.cornerRadius = 12
    }
    
    func setupLayout() {
        addSubviews(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
