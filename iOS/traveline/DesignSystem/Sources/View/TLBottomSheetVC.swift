//
//  TLBottomSheetVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/16.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

public protocol TLBottomSheetDelegate: AnyObject {
    func bottomSheetDidDisappear(data: Any)
}

open class TLBottomSheetVC: UIViewController {
    
    // MARK: - UI Components
    
    private enum Margin {
        static let positive: CGFloat = 16
        static let negative: CGFloat = -16
    }
    
    private enum HeaderSize {
        static let height: CGFloat = 60
        static let yOffset: CGFloat = 4
        static let lineWidth: CGFloat = 1
    }
    
    private let header: UIView = .init()
    private let headerButton: UIButton = .init()
    private let headerLine: UIView = .init()
    private let headerLabel: TLLabel = .init(
        font: .subtitle2,
        text: "",
        color: TLColor.white
    )
    /// 상속받은 ViewController에서 사용할 뷰를 여기에 추가합니다.
    public let main: UIView = .init()
    
    // MARK: - Properties
    
    private let titleText: String
    private var hasCompleteButton: Bool
    private var detentHeight: CGFloat?
    public weak var delegate: TLBottomSheetDelegate?
    
    // MARK: - Life Cycle
    
    public init(title: String, hasCompleteButton: Bool = true, detentHeight: CGFloat? = nil) {
        self.titleText = title
        self.hasCompleteButton = hasCompleteButton
        self.detentHeight = detentHeight
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBotomSheet()
        setupAttributes()
        setupLayout()
    }
    
    // MARK: - Functions
    
    @objc private func headerButtonTapped() {
        self.dismiss(animated: true) {
            self.completeAction()
        }
    }
    
    private func bottomSheetDetent() -> [UISheetPresentationController.Detent] {
        guard let detentHeight = detentHeight else { return [.medium()] }
        let detentIdentifier = UISheetPresentationController.Detent.Identifier("customDetent")
        let customDetent = UISheetPresentationController.Detent.custom(identifier: detentIdentifier) { _ in
            return detentHeight
        }
        return [customDetent]
    }
    
    /// 상속받은 ViewController에서 완료 버튼이 탭될 때 액션을 정의합니다.
    open func completeAction() { }
    
}

// MARK: - Setup Functions

private extension TLBottomSheetVC {
    
    private func setupBotomSheet() {
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = bottomSheetDetent()
            sheetPresentationController.prefersGrabberVisible = true
        }
    }
    
    private func setupAttributes() {
        [
            header,
            headerLine,
            headerLabel,
            headerButton,
            main
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.backgroundColor = TLColor.black
        headerLine.backgroundColor = TLColor.lineGray
        main.backgroundColor = TLColor.black
        headerLabel.text = titleText
        setupHeaderButton()
    }
    
    private func setupHeaderButton() {
        if hasCompleteButton {
            headerButton.setTitle("완료", for: .normal)
            headerButton.setTitleColor(TLColor.main, for: .normal)
            headerButton.titleLabel?.font = TLFont.subtitle2.font
            headerButton.addTarget(self, action: #selector(headerButtonTapped), for: .touchUpInside)
        }
    }
    
    private func setupLayout() {
        view.addSubview(header)
        view.addSubview(main)
        
        header.addSubview(headerLabel)
        header.addSubview(headerButton)
        header.addSubview(headerLine)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.heightAnchor.constraint(equalToConstant: HeaderSize.height),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            headerLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor, constant: HeaderSize.yOffset),
            
            headerButton.centerYAnchor.constraint(equalTo: header.centerYAnchor, constant: HeaderSize.yOffset),
            headerButton.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: Margin.negative),
            
            headerLine.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            headerLine.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            headerLine.bottomAnchor.constraint(equalTo: header.bottomAnchor),
            headerLine.heightAnchor.constraint(equalToConstant: HeaderSize.lineWidth),
            
            main.topAnchor.constraint(equalTo: header.bottomAnchor),
            main.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            main.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            main.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
