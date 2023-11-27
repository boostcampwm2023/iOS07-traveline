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
    
}

// MARK: - Setup Functions

private extension ContainerVC {
    
    func setupAttributes() {
   //     let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(shadowTapped(_:)))
     //   tapGestureRecognizer.numberOfTapsRequired = 1
      //  tapGestureRecognizer.delegate = self
       // self.shadowView.addGestureRecognizer(tapGestureRecognizer)
    }
    
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
        self.sideMenuVC.menuView.frame = CGRect(
            x: 0,
            y: 0,
            width: self.homeVC.view.frame.size.width / 16 * 9,
            height: self.homeVC.view.frame.size.height
        )
        self.sideMenuVC.view.insertSubview(shadowView, at: 0)
        self.sideMenuVC.view.isHidden = true
        self.shadowView.isHidden = true
        self.shadowView.frame = self.view.bounds
        self.shadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.shadowView.backgroundColor = TLColor.black
        self.shadowView.alpha = 0.7
        
    }
    
}

// MARK: - SideMenuDelegate

extension ContainerVC: SideMenuDelegate {
    func shadowTouched() {
        closeSideMenu(nil)
    }
    
    func didSelect(menuItem: SideMenuVC.Options) {
        toggleSideMenu(completion: nil)
        
        switch menuItem {
        case .profileEdit:
            navigationVC?.pushViewController(ProfileEditingVC(), animated: true)
        case .myPostList:
            // TODO: - myPostListView 만들면 변경하기
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
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0,
            options: .layoutSubviews,
            animations: {
                self.sideMenuVC.view.isHidden = false
                self.shadowView.isHidden = false
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
                self.shadowView.isHidden = true
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
/*
extension ContainerVC: UIGestureRecognizerDelegate {
    @objc func shadowTapped(_ sender: UITapGestureRecognizer) {
            print("hi")
        if sender.state == .ended {
            print("hi")
            closeSideMenu(nil)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("??")
        return true
    }
}*/

@available(iOS 17, *)
#Preview("ContainerVC") {
    let vc = ContainerVC()
    return vc
}
