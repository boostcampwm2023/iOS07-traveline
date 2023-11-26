//
//  SideMenuVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

protocol SideMenuDelegate: AnyObject {
    func didSelect(menuItem: SideMenuVC.Options)
}

final class SideMenuVC: UIViewController {
    
    enum Options {
        case profileEdit
        case myPostList
        case setting
    }
    
    // MARK: - UI Components
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.alignment = .leading
        view.distribution = .fill
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private let profileLabel: ProfileLabel = .init()
    
    private let myPostListLabel: UIButton = {
        var config = UIButton.Configuration.borderless()
        let button = UIButton()
        config.title = "내가 작성한 글"
        config.baseForegroundColor = TLColor.white
        
        button.titleLabel?.font = TLFont.subtitle1.font
        button.configuration = config
        
        return button
    }()
    
    let settingLabel: UIButton = {
        var config = UIButton.Configuration.borderless()
        let button = UIButton()
        config.title = "설정"
        config.baseForegroundColor = TLColor.white
        
        button.titleLabel?.font = TLFont.subtitle1.font
        button.configuration = config
        
        return button
    }()
    
    // MARK: - Properties
    
    weak var delegate: SideMenuDelegate?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        setupLayout()
    }
    
    // MARK: - Functions
    
    @objc private func profileEditTapped() {
        delegate?.didSelect(menuItem: .profileEdit)
    }
    
    @objc private func myPostListTapped() {
        delegate?.didSelect(menuItem: .myPostList)
    }
    
    @objc private func settingTapped() {
        delegate?.didSelect(menuItem: .setting)
    }
    
}

// MARK: - Setup Functions

private extension SideMenuVC {
    
    func setupAttributes() {
        profileLabel.isUserInteractionEnabled = true
        profileLabel.editButton.addTarget(self, action: #selector(profileEditTapped), for: .touchUpInside)
        profileLabel.addTarget(self, action: #selector(profileEditTapped), for: .touchUpInside)
        myPostListLabel.addTarget(self, action: #selector(myPostListTapped), for: .touchUpInside)
        settingLabel.addTarget(self, action: #selector(settingTapped), for: .touchUpInside)
        view.backgroundColor = TLColor.black
    }
    
    func setupLayout() {
        view.addSubview(stackView)
        view.addSubview(profileLabel)
        stackView.addSubview(profileLabel)
        stackView.addArrangedSubviews(
            profileLabel,
            myPostListLabel,
            settingLabel
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.arrangedSubviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
}

extension SideMenuVC: UIGestureRecognizerDelegate {
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else { return false }
            if view === stackView {
                return false
            }
        return true
    }
}

@available(iOS 17, *)
#Preview("SideMenuVC") {
    let vc = SideMenuVC()
    let homeNV = UINavigationController(rootViewController: vc)
    return homeNV
}
