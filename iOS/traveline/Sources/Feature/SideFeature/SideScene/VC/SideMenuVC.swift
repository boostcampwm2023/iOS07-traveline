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
    func shadowTouched()
}

final class SideMenuVC: UIViewController {
    
    enum Options {
        case profileEdit
        case myPostList
        case setting
    }
    
    private enum Metric {
        static let margin: CGFloat = 16.0
        static let spacing: CGFloat = 16.0
    }
    
    private enum Constants {
        static let myListTitle = "내가 작성한 글"
        static let settingTitle = "설정"
    }
    
    // MARK: - UI Components
    
    let menuView: UIView = .init()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Metric.margin
        view.alignment = .leading
        view.distribution = .fill
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private let profileLabel: ProfileLabel = .init()
    
    private let myPostListLabel: UIButton = {
        var config = UIButton.Configuration.borderless()
        let button = UIButton()
        config.title = Constants.myListTitle
        config.baseForegroundColor = TLColor.white
        
        button.titleLabel?.font = TLFont.subtitle1.font
        button.configuration = config
        
        return button
    }()
    
    let settingLabel: UIButton = {
        var config = UIButton.Configuration.borderless()
        let button = UIButton()
        config.title = Constants.settingTitle
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
    
    @objc private func shadowTouched() {
        delegate?.shadowTouched()
    }
    
}

// MARK: - Setup Functions

private extension SideMenuVC {
    
    func setupAttributes() {
        profileLabel.addTarget(self, action: #selector(profileEditTapped), for: .touchUpInside)
        myPostListLabel.addTarget(self, action: #selector(myPostListTapped), for: .touchUpInside)
        settingLabel.addTarget(self, action: #selector(settingTapped), for: .touchUpInside)
        menuView.backgroundColor = TLColor.black
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(shadowTouched))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        tapGesture.isEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupLayout() {
        view.addSubview(menuView)
        menuView.addSubview(stackView)
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
            menuView.topAnchor.constraint(equalTo: view.topAnchor),
            menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: menuView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: menuView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor, constant: Metric.margin),
            stackView.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -Metric.margin)
        ])
    }
    
}

// MARK: - extension UIGestureRecognizerDelegate

extension SideMenuVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else { return false }
        if view === menuView {
            return false
        }
        return true
    }
}

