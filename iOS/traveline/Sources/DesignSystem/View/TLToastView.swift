//
//  TLToast.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/09.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit



final class TLToastView: UIView {
    
    enum ToastType: String {
        case success = "Success"
        case failure = "Failure"
        case warning = "Warning"
        
        var image: UIImage {
            switch self {
            case .success:
                return TLImage.ToastIcon.success.image
            case .failure:
                return TLImage.ToastIcon.failure.image
            case .warning:
                return TLImage.ToastIcon.warning.image
            }
        }
    }
    
    private enum Metric {
        static let margin: CGFloat = 16.0
        static let toastY: CGFloat = 120.0
        static let toastHeight: CGFloat = 100.0
    }
    
    // MARK: - UI Components
    
    private let toastStackView: UIStackView = {
        let stack  = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 16
        
        return stack
    }()
    
    private let labelStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .leading
        
        return stack
    }()
    
    private let icon: UIImageView = .init()
    private let titleLabel: TLLabel = .init(font: TLFont.heading1, color: TLColor.white)
    private let contentLabel: TLLabel = .init(font: TLFont.body1, color: TLColor.white)
    
    // MARK: - properties
    
    private let toastType: ToastType
    private var message: String
    
    // MARK: - initialize
    
    init(type: ToastType = .success, message: String = "") {
        self.toastType = type
        self.message = message
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func setMessage(_ message: String) {
        self.message = message
        contentLabel.setText(to: message)
    }
    
    func show(in view: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: Metric.toastY),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.margin),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.margin),
            heightAnchor.constraint(equalToConstant: Metric.toastHeight)
        ])
        
        UIView.animate(
            withDuration: 2.0,
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
        icon.image = toastType.image
        titleLabel.setText(to: toastType.rawValue)
        contentLabel.setText(to: message)
        
        backgroundColor = TLColor.darkGray
        layer.cornerRadius = 12
    }
    
    func setupLayout() {
        addSubview(toastStackView)
        toastStackView.addArrangedSubviews(icon, labelStackView)
        labelStackView.addArrangedSubviews(titleLabel, contentLabel)
        [
            toastStackView,
            icon,
            labelStackView,
            titleLabel,
            contentLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            toastStackView.topAnchor.constraint(equalTo: topAnchor),
            toastStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.margin),
            toastStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}

@available(iOS 17, *)
#Preview("TLSearchInfoView") {
    let view = TLToastView(type: .success, message: "hahihuheho")
    return view
}
