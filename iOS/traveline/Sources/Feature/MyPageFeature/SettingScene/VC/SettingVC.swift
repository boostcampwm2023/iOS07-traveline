//
//  SettingVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/20.
//  Copyright © 2023 traveline. All rights reserved.
//

import AuthenticationServices
import Combine
import SafariServices
import UIKit

enum ServiceGuideType: String, CaseIterable {
    case termsOfService = "이용약관"
    case privacyPolicy = "개인정보 처리방침"
    
    var link: String {
        switch self {
        case .termsOfService: return Literal.Setting.termsOfServiceURL
        case .privacyPolicy: return Literal.Setting.privacyPolicyURL
        }
    }
    
    func button() -> UIButton {
        let button = UIButton()
        button.setTitle(self.rawValue, for: .normal)
        button.setTitleColor(TLColor.white, for: .normal)
        button.titleLabel?.font = TLFont.body1.font
        
        return button
    }
    
}

// MARK: - Setting VC

final class SettingVC: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var tlNavigationBar: TLNavigationBar = .init(title: "설정", vc: self)
    
    private let lineWidth: CGFloat = 1
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 16
        return stackView
    }()
    
    private let serviceGuides: [ServiceGuideType: UIButton] = {
        return ServiceGuideType.allCases.reduce(into: [:]) { result, key in
            result[key] = key.button()
        }
    }()
    
    private let line: UIView = {
        let line = UIView()
        line.backgroundColor = TLColor.lineGray
        return line
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(TLColor.white, for: .normal)
        button.titleLabel?.font = TLFont.body1.font
        return button
    }()
    
    private let withdrawalButton: UIButton = {
        let button = UIButton()
        button.setTitle("탈퇴하기", for: .normal)
        button.setTitleColor(TLColor.white, for: .normal)
        button.titleLabel?.font = TLFont.body1.font
        return button
    }()
    
    // MARK: - Properties
    
    private let viewModel: SettingViewModel
    private var cancellabels: Set<AnyCancellable> = .init()
    
    // MARK: - Initialize
    
    init(viewModel: SettingViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Functions
    
    @objc private func logoutButtonTapped() {
        showLogoutAlert()
    }
    
    @objc private func withdrawalButtonTapped() {
        showWithdrawalAlert()
    }
    
    private func showLogoutAlert() {
        let alert = TLAlertController(
            title: "로그아웃",
            message: "정말 로그아웃하시겠습니까?",
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let logout = UIAlertAction(title: "로그아웃", style: .destructive) { [weak self] _ in
            self?.viewModel.sendAction(.logoutButtonTapped)
        }
        
        alert.addActions([cancel, logout])
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showWithdrawalAlert() {
        let alert = TLAlertController(
            title: "정말 탈퇴하시겠습니까?",
            message: "작성한 글들을 다시 볼 수 없습니다.",
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "취소", style: .default)
        let withdrawal = UIAlertAction(title: "탈퇴하기", style: .destructive) { [weak self] _ in
            self?.viewModel.sendAction(.withdrawalButtonTapped)
        }
        
        alert.addActions([withdrawal, cancel])
        cancel.setValue(TLColor.gray, forKey: "titleTextColor")
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Setup Functions

extension SettingVC {
    
    private func setupAttributes() {
        view.backgroundColor = TLColor.black
        
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        withdrawalButton.addTarget(self, action: #selector(withdrawalButtonTapped), for: .touchUpInside)
        setupServiceGuideButton()
    }
    
    private func setupServiceGuideButton() {
        serviceGuides.forEach { type, button in
            let action = UIAction(handler: { [weak self] _ in
                guard let url = URL(string: type.link),
                      UIApplication.shared.canOpenURL(url),
                      let self = self else { return }
                
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true)
            })
            button.addAction(action, for: .touchUpInside)
        }
    }
    
    private func setupLayout() {
        view.addSubviews(tlNavigationBar, stackView)
        [
            serviceGuides[.termsOfService] ?? UIButton(),
            serviceGuides[.privacyPolicy] ?? UIButton(),
            line,
            logoutButton,
            withdrawalButton
        ].forEach {
            stackView.addArrangedSubview($0)
            $0.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16).isActive = true
        }
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tlNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tlNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tlNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tlNavigationBar.heightAnchor.constraint(equalToConstant: BaseMetric.tlheight),
            
            stackView.topAnchor.constraint(equalTo: tlNavigationBar.bottomAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            line.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: lineWidth)
        ])
    }
    
    func bind() {
        viewModel.state
            .map(\.moveToLogin)
            .filter { $0 }
            .removeDuplicates()
            .sink { _ in
                guard let firstScene = UIApplication.shared.connectedScenes.first,
                      let sceneDelegate = firstScene.delegate as? SceneDelegate else { return }
                
                sceneDelegate.changeRootViewControllerToLogin()
            }
            .store(in: &cancellabels)
        
        viewModel.state
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
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension SettingVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        viewModel.sendAction(.didCompleteWithAppleAuth(authorization))
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        viewModel.sendAction(.didCompleteWithError)
    }
}
