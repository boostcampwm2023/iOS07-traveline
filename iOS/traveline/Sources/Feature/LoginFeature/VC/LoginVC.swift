//
//  LoginVC.swift
//  traveline
//
//  Created by 김영인 on 2023/11/28.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class LoginVC: UIViewController {
    
    private enum Metric {
        static let topInset: CGFloat = 200 * BaseMetric.Adjust.height
        static let bottomInset: CGFloat = 130 * BaseMetric.Adjust.height
        static let padding: CGFloat = 20
        static let height: CGFloat = 50
    }
    
    // MARK: - UI Components
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = TLImage.Common.logo
        return imageView
    }()
    
    private let appleLoginButton: AppleLoginButton = .init()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        setupLayout()
    }
}

// MARK: - Setup Functions

private extension LoginVC {
    func setupAttributes() {
        view.backgroundColor = TLColor.black
    }
    
    func setupLayout() {
        view.addSubviews(logoImageView, appleLoginButton)
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.topInset),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            appleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.padding),
            appleLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.padding),
            appleLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Metric.bottomInset),
            appleLoginButton.heightAnchor.constraint(equalToConstant: Metric.height)
        ])
    }
}

@available(iOS 17, *)
#Preview("LoginVC") {
    let view = LoginVC()
    return view
}
