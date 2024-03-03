//
//  AutoLoginVC.swift
//  traveline
//
//  Created by 김태현 on 12/7/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import UIKit

final class AutoLoginVC: UIViewController {
    
    private enum Metric {
        static let topInset: CGFloat = 200 * BaseMetric.Adjust.height
    }
    
    // MARK: - UI Components
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = TLImage.Common.logo
        return imageView
    }()
    
    // MARK: - Properties
    
    private let viewModel: AutoLoginViewModel
    private var cancellabels: Set<AnyCancellable> = .init()
    
    // MARK: - Initializer
    
    init(viewModel: AutoLoginViewModel) {
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
        viewModel.sendAction(.startAutoLogin)
    }
    
}

// MARK: - Setup Functions

private extension AutoLoginVC {
    func setupAttributes() {
        view.backgroundColor = TLColor.black
    }
    
    func setupLayout() {
        view.addSubviews(logoImageView)
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.topInset),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func bind() {
        viewModel.state
            .map(\.moveToLogin)
            .filter { $0 }
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, _ in
                let loginVC = VCFactory.makeLoginVC()
                loginVC.modalPresentationStyle = .overFullScreen
                owner.present(loginVC, animated: false)
            }
            .store(in: &cancellabels)
        
        viewModel.state
            .map(\.moveToMain)
            .filter { $0 }
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, _ in
                let rootContainerVC = VCFactory.makeRootContainerVC()
                rootContainerVC.modalPresentationStyle = .overFullScreen
                owner.present(rootContainerVC, animated: false)
            }
            .store(in: &cancellabels)
    }
}
