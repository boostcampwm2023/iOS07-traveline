//
//  SettingVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/20.
//  Copyright © 2023 traveline. All rights reserved.
//

import SafariServices
import UIKit

enum ServiceGuideType: String, CaseIterable {
    case license = "라이센스"
    case termsOfUse = "이용약관"
    case privacyPolicy = "개인정보 처리방침"
    
    var link: String {
        switch self {
        case .license: return "https://www.apple.com"
        case .termsOfUse: return "https://www.naver.com"
        case .privacyPolicy: return "https://www.daum.net"
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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        setupLayout()
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
        let logout = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
            // logout action
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
        let withdrawal = UIAlertAction(title: "탈퇴하기", style: .destructive) { _ in
            // withdrawal action
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
            serviceGuides[.license] ?? UIButton(),
            serviceGuides[.termsOfUse] ?? UIButton(),
            serviceGuides[.privacyPolicy] ?? UIButton(),
            line,
            logoutButton,
            withdrawalButton
        ].forEach {
            stackView.addArrangedSubview($0)
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
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            line.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: lineWidth)
        ])
    }
    
}

@available(iOS 17, *)
#Preview("ProfileEditingVC") {
    let vc = SettingVC()
    return vc
}
