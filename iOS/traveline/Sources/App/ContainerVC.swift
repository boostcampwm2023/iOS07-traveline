//
//  ContainerVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/26.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class ContainerVC: UIViewController {
    
    enum SideMenuState {
        case opened
        case closed
    }
    
    // MARK: - UI Components
    
    private let sideMenuVC: SideMenuVC = SideMenuVC()
    private let homeVC: HomeVC = .init(viewModel: HomeViewModel())
    private let shadowView: UIView = .init()
    private var navigationVC: UINavigationController?
    private var selectedVC: UIViewController?
    
    //MARK: - Properties
    
    private var sideMenuState: SideMenuState = .closed
    
    // MARK: - Initialize
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupChildVC()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - Setup Functions

private extension ContainerVC {
    
    func setupChildVC() {
        let navigationVC = UINavigationController(rootViewController: homeVC)
        homeVC.delegate = self
        addChild(navigationVC)
        view.addSubview(navigationVC.view)
        navigationVC.didMove(toParent: self)
        self.navigationVC = navigationVC
        
        addChild(sideMenuVC)
        view.addSubview(sideMenuVC.view)
        sideMenuVC.didMove(toParent: self)
        sideMenuVC.delegate = self
    }
    
    func setupLayout() {
        self.sideMenuVC.view.frame = CGRect(
            x: 0,
            y: 0,
            width: self.homeVC.view.frame.size.width / 16 * 9,
            height: self.homeVC.view.frame.size.height
        )
        self.sideMenuVC.view.isHidden = true
                self.homeVC.view.addSubview(self.shadowView)
        
        self.shadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.shadowView.backgroundColor = TLColor.black
        self.shadowView.alpha = 0.5
    }
    
}

// MARK: - SideMenuDelegate

extension ContainerVC: SideMenuDelegate {
    func didSelect(menuItem: SideMenuVC.Options) {
        toggleSideMenu(completion: nil)
        
        switch menuItem {
        case .profileEdit:
            navigationVC?.pushViewController(ProfileEditingVC(), animated: true)
        case .myPostList:
            //TODO: - myPostListView 만들면 변경하기
            break
        case .setting:
            navigationVC?.pushViewController(SettingVC(), animated: true)
        }
    }
    
}

// MARK: - HomeViewDelegate

extension ContainerVC: HomeViewDelegate {
    func sideMenuTapped() {
        toggleSideMenu(completion: nil)
    }
    
    private func toggleSideMenu(completion: (() -> Void)?) {
        switch sideMenuState {
        case .closed: openSideMenu()
        case .opened: closeSideMenu(completion)
        }
    }
    
    private func openSideMenu() {
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.sideMenuVC.view.isHidden = false
            },
            completion: { [weak self] _ in
                guard let self else { return }
                self.sideMenuState = .opened
            })
    }
    
    private func closeSideMenu(_ completion: (() -> Void)?) {
        UIView.animate(
            withDuration: 0.5,
            animations: { [weak self] in
                guard let self else { return }
                self.sideMenuVC.view.isHidden = true
            },
            completion: { [weak self] _ in
                guard let self else { return }
                self.sideMenuState = .closed
                DispatchQueue.main.async {
                    completion?()
                }
            })
    }
    
}

@available(iOS 17, *)
#Preview("ContainerVC") {
    let vc = ContainerVC()
    return vc
}
