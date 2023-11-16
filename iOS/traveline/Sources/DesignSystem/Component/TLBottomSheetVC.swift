//
//  TLBottomSheetVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/16.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

protocol TLBottomSheetDelegate: AnyObject {
    func bottomSheet(data: Any)
}

class TLBottomSheetVC: UIViewController {
    
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
    let main: UIView = .init()
    
    // MARK: - Properties
    
    private let titleText: String
    private var hasCompleteButton: Bool
    weak var delegate: TLBottomSheetDelegate?
    
    // MARK: - Life Cycle
    
    init(title: String, hasCompleteButton: Bool = true) {
        self.titleText = title
        self.hasCompleteButton = hasCompleteButton
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        setupLayout()
    }
    
    // MARK: - Functions
    
    @objc private func headerButtonTapped() {
        self.dismiss(animated: true) {
            self.completeAction()
        }
    }
    
    /// 상속받은 ViewController에서 완료 버튼이 탭될 때 액션을 정의합니다.
    func completeAction() { }
    
}

// MARK: - Setup Functions

private extension TLBottomSheetVC {
    func setupAttributes() {
        view.backgroundColor = TLColor.black
        
        header.translatesAutoresizingMaskIntoConstraints = false
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = titleText
        
        if hasCompleteButton {
            setupHeaderButton()
        }
        
        headerLine.translatesAutoresizingMaskIntoConstraints = false
        headerLine.backgroundColor = TLColor.lineGray
        
        main.translatesAutoresizingMaskIntoConstraints = false
        main.backgroundColor = TLColor.black
    }
    
    private func setupHeaderButton() {
        headerButton.translatesAutoresizingMaskIntoConstraints = false
        headerButton.setTitle("완료", for: .normal)
        headerButton.setTitleColor(TLColor.main, for: .normal)
        headerButton.titleLabel?.font = TLFont.subtitle2.font
        headerButton.addTarget(self, action: #selector(headerButtonTapped), for: .touchUpInside)
    }
    
    func setupLayout() {
        view.addSubview(header)
        view.addSubview(main)
        
        header.addSubview(headerLabel)
        header.addSubview(headerButton)
        header.addSubview(headerLine)
        
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
            sheetPresentationController.prefersGrabberVisible = true
        }
        
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
