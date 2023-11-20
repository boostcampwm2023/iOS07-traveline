//
//  SettingVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/19.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class SettingVC: UIViewController {
    // MARK: - UI Components
    private let lineWidth: CGFloat = 1
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 12
        return stackView
    }()
    
    let license = ServiceGuideItem.license.view()
    let termsOfUse = ServiceGuideItem.termsOfUse.view()
    let privacyPolicy = ServiceGuideItem.privacyPolicy.view()
    
    let line: UIView = {
        let line = UIView()
        line.backgroundColor = TLColor.lineGray
        return line
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(TLColor.white, for: .normal)
        return button
    }()
    
    let withdrawalButton: UIButton = {
        let button = UIButton()
        button.setTitle("탈퇴하기", for: .normal)
        button.setTitleColor(TLColor.white, for: .normal)
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
        self.navigationItem.title = "설정"
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        withdrawalButton.addTarget(self, action: #selector(withdrawalButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(stackView)
        [
            license,
            termsOfUse,
            privacyPolicy,
            line,
            logoutButton,
            withdrawalButton
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            line.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: lineWidth)
        ])
    }
    
}

