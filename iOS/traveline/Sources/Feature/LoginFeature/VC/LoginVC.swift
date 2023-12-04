//
//  LoginVC.swift
//  traveline
//
//  Created by 김영인 on 2023/11/28.
//  Copyright © 2023 traveline. All rights reserved.
//

import AuthenticationServices
import Combine
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
    
    // MARK: - Properties
    
    private let viewModel: LoginViewModel
    private var cancellabels: Set<AnyCancellable> = .init()
    
    // MARK: - Initialzier
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        setupLayout()
        bind()
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
    
    func bind() {
        appleLoginButton
            .tapPublisher
            .withUnretained(self)
            .sink { owner, _ in
                owner.viewModel.sendAction(.startAppleLogin)
            }
            .store(in: &cancellabels)
        
        viewModel.$state
            .compactMap(\.appleIDRequests)
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, requests in
                let controller = ASAuthorizationController(authorizationRequests: requests)
                controller.delegate = owner
                controller.presentationContextProvider = owner as? ASAuthorizationControllerPresentationContextProviding
                controller.performRequests()
            }
            .store(in: &cancellabels)
        
        viewModel.$state
            .map(\.isSuccessLogin)
            .filter { $0 }
            .withUnretained(self)
            .sink { _, _ in
                // TODO: 로그인 성공 후 로직 구현
            }
            .store(in: &cancellabels)
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension LoginVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        viewModel.sendAction(.successAppleLogin(authorization))
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        viewModel.sendAction(.failAppleLogin)
    }
}

@available(iOS 17, *)
#Preview("LoginVC") {
    let vm = LoginViewModel()
    let view = LoginVC(viewModel: vm)
    return view
}
