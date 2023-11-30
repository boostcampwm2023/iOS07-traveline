//
//  ContainerVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/26.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class RootContainerVC: UIViewController {
    
    enum SideMenuState {
        case opened
        case closed
    }
    
    // MARK: - UI Components
    
    private let sideMenuVC: SideMenuVC = .init(viewModel: SideMenuViewModel())
    private let homeVC: HomeVC = .init(viewModel: HomeViewModel())
    private let shadowView: UIView = .init()
    private var navigationVC: UINavigationController?
    private var selectedVC: UIViewController?
    
    // MARK: - Properties
    
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
    
    // MARK: - Functions
    
    private func openSideMenu() {
        self.addChild(self.sideMenuVC)
        self.sideMenuVC.view.frame = self.sideMenuHiddenPosition()
        self.view.addSubview(self.sideMenuVC.view)
        self.sideMenuVC.didMove(toParent: self)
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.5,
            options: .curveEaseInOut,
            animations: {
                self.sideMenuVC.view.frame = self.sideMenuDisplayPosition()
                self.sideMenuVC.didMove(toParent: self)
                self.shadowView.isHidden = false
            },
            completion: { [weak self] _ in
                guard let self else { return }
                self.sideMenuState = .opened
            })
    }
    
    private func closeSideMenu() {
        self.sideMenuVC.view.frame = self.sideMenuDisplayPosition()
        
        UIView.animate(
            withDuration: 0.5,
            animations: { [weak self] in
                guard let self else { return }
                self.sideMenuVC.view.frame = self.sideMenuHiddenPosition()
            },
            completion: { [weak self] _ in
                guard let self else { return }
                self.sideMenuState = .closed
                self.willMove(toParent: nil)
                self.shadowView.isHidden = true
                self.sideMenuVC.view.removeFromSuperview()
                self.sideMenuVC.removeFromParent()
            })
    }
    
    private func sideMenuDisplayPosition() -> CGRect {
        return CGRect(
            x: 0,
            y: 0,
            width: self.sideMenuVC.view.frame.width,
            height: self.sideMenuVC.view.frame.height
        )
    }
    
    private func sideMenuHiddenPosition() -> CGRect {
        return CGRect(
            x: -self.sideMenuVC.view.frame.width,
            y: 0,
            width: self.sideMenuVC.view.frame.width,
            height: self.sideMenuVC.view.frame.height
        )
    }
    
    @objc func shadowTouched() {
        closeSideMenu()
    }
}

// MARK: - Setup Functions

private extension RootContainerVC {
    
    func setupChildVC() {
        let navigationVC = UINavigationController(rootViewController: homeVC)
        homeVC.delegate = self
        addChild(navigationVC)
        view.addSubview(navigationVC.view)
        navigationVC.didMove(toParent: self)
        self.navigationVC = navigationVC
        
        sideMenuVC.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(shadowTouched))
        tapGesture.delegate = self
        shadowView.addGestureRecognizer(tapGesture)
    }
    
    func setupLayout() {
        self.sideMenuVC.view.frame = CGRect(
            x: 0,
            y: 0,
            width: self.homeVC.view.frame.size.width / 16 * 9,
            height: self.homeVC.view.frame.size.height
        )
        view.insertSubview(shadowView, at: 1)
        
        self.shadowView.isHidden = true
        self.shadowView.frame = self.view.bounds
        self.shadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.shadowView.backgroundColor = TLColor.black
        self.shadowView.alpha = 0.7
        
    }
    
}

// MARK: - SideMenuDelegate

extension RootContainerVC: SideMenuDelegate {
    
    func didSelect(menuItem: SideMenuVC.Options) {
        closeSideMenu()
        
        switch menuItem {
        case .profileEdit:
            let profile = Profile(
                id: "1234",
                imageURL: "leaf",
                name: "hongki"
            )
            let viewModel = ProfileEditingViewModel(profile: profile)
            navigationVC?.pushViewController(ProfileEditingVC(viewModel: viewModel), animated: true)
        case .myPostList:
            // TODO: - myPostListView 만들면 변경하기
            navigationVC?.pushViewController(MyPostListVC(), animated: true)
            break
        case .setting:
            navigationVC?.pushViewController(SettingVC(), animated: true)
        }
    }
    
}

// MARK: - HomeViewDelegate

extension RootContainerVC: HomeViewDelegate {
    func sideMenuTapped() {
        switch sideMenuState {
        case .closed: openSideMenu()
        case .opened: closeSideMenu()
        }
    }
    
}

// MARK: - extension UIGestureRecognizerDelegate

extension RootContainerVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else { return false }
        if view == shadowView {
            return true
        }
        return false
    }
}
