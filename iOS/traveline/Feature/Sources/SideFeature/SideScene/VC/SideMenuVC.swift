//
//  SideMenuVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import UIKit

import DesignSystem

protocol SideMenuDelegate: AnyObject {
    func didSelect(menuItem: SideMenuVC.Options)
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
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Metric.margin
        view.alignment = .leading
        view.distribution = .fill
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private let profileButton: ProfileLabel = .init()
    
    private let myPostListButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        let button = UIButton()
        config.title = Constants.myListTitle
        config.baseForegroundColor = TLColor.white
        
        button.titleLabel?.font = TLFont.subtitle1.font
        button.configuration = config
        
        return button
    }()
    
    let settingButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        let button = UIButton()
        config.title = Constants.settingTitle
        config.baseForegroundColor = TLColor.white
        
        button.titleLabel?.font = TLFont.subtitle1.font
        button.configuration = config
        
        return button
    }()
    
    // MARK: - Properties
    
    private var cancellables: Set<AnyCancellable> = .init()
    private let viewModel: SideMenuViewModel
    weak var delegate: SideMenuDelegate?
    
    // MARK: - Initializer
    
    init(viewModel: SideMenuViewModel) {
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
        viewModel.sendAction(.viewWillAppear)
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
        profileButton.editButton.addTarget(self, action: #selector(profileEditTapped), for: .touchUpInside)
        myPostListButton.addTarget(self, action: #selector(myPostListTapped), for: .touchUpInside)
        settingButton.addTarget(self, action: #selector(settingTapped), for: .touchUpInside)
        view.backgroundColor = TLColor.black
        
    }
    
    func setupLayout() {
        view.addSubview(stackView)
        stackView.addArrangedSubviews(
            profileButton,
            myPostListButton,
            settingButton
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.arrangedSubviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.margin),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.margin)
        ])
    }
    
    func bind() {
        viewModel.state
            .map(\.profile)
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, profile in
                owner.profileButton.updateProfile(profile)
            }
            .store(in: &cancellables)
    }
    
}
