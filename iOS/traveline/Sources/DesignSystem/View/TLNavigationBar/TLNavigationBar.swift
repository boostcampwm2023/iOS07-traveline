//
//  TLNavigationBar.swift
//  traveline
//
//  Created by 김영인 on 2023/11/27.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit
import Combine

protocol TLNavigationBarDelegate: AnyObject {
    func rightButtonDidTapped()
}

final class TLNavigationBar: UIView {
    
    private enum Metric {
        static let inset: CGFloat = 16
    }
    
    private enum Constants {
        static let complete: String = "완료"
    }
    
    // MARK: - UI Components
    
    private let titleLabel: TLLabel = .init(
        font: .subtitle1,
        color: TLColor.white
    )
    
    private let leftBarButton: UIButton = {
        let button = UIButton()
        button.setImage(TLImage.Common.back, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let rightBarButton: UIButton = .init()
    
    // MARK: - Properties
    
    private let title: String
    private weak var vc: UIViewController?
    
    weak var delegate: TLNavigationBarDelegate?
    
    // MARK: - Initializer
    
    init(title: String = "", vc: UIViewController) {
        self.title = title
        self.vc = vc
        
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    /// 네비게이션 바 우측에 버튼을 추가합니다.
    /// - Parameters:
    ///   - image: 추가할 버튼 이미지
    ///   - menu:  추가할 UIMenu (옵셔널)
    @discardableResult
    func addRightButton(image: UIImage, menu: UIMenu?) -> Self {
        setupRightButton()
        
        rightBarButton.setImage(image, for: .normal)
        rightBarButton.imageView?.contentMode = .scaleAspectFit
        guard let menu else { return self }
        rightBarButton.menu = menu
        rightBarButton.showsMenuAsPrimaryAction = true
        
        return self
    }
    
    /// 네비게이션 바 우측에 [완료] 버튼을 추가합니다.
    @discardableResult
    func addCompleteButton() -> Self {
        setupRightButton()
        
        rightBarButton.setTitle(Constants.complete, for: .normal)
        rightBarButton.setTitleColor(TLColor.main, for: .normal)
        rightBarButton.setTitleColor(TLColor.unselectedGray, for: .disabled)
        rightBarButton.titleLabel?.font = TLFont.body1.font
        rightBarButton.isEnabled = false
        
        return self
    }
    
    /// 네비게이션 바 우측 버튼의 isEnabled 여부를 업데이트합니다.
    func isRightButtonEnabled(_ isEnabled: Bool) {
        rightBarButton.isEnabled = isEnabled
    }
    
    /// 네비게이션 바 타이틀을 설정합니다.
    func setupTitle(to text: String) {
        titleLabel.setText(to: text)
    }
    
    // MARK: - @objc Functions
    
    @objc private func leftButtonDidTapped() {
        vc?.navigationController?.popViewController(animated: true)
    }
    
    @objc private func rightButtonDidTapped() {
        delegate?.rightButtonDidTapped()
    }
}

// MARK: - Setup Functions

private extension TLNavigationBar {
    func setupAttributes() {
        backgroundColor = TLColor.black
        titleLabel.setText(to: title)
        
        leftBarButton.addTarget(self, action: #selector(leftButtonDidTapped), for: .touchUpInside)
    }
    
    func setupLayout() {
        addSubviews(leftBarButton, titleLabel)
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            leftBarButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.inset),
            leftBarButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setupRightButton() {
        rightBarButton.addTarget(self, action: #selector(rightButtonDidTapped), for: .touchUpInside)
        
        addSubview(rightBarButton)
        rightBarButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rightBarButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metric.inset),
            rightBarButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
