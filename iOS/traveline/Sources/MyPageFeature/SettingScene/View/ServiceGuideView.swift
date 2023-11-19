//
//  ServiceGuideView.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/19.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

enum ServiceGuideItem: String {
    case license = "라이센스"
    case termsOfUse = "이용약관"
    case privacyPolicy = "개인정보 처리방침"
    
    var link: String {
        switch self {
        case .license: return "license link"
        case .termsOfUse: return "terms of use link"
        case .privacyPolicy: return "privacy policy link"
        }
    }
    
    func view() -> ServiceGuideView {
        return ServiceGuideView(title: self.rawValue, link: self.link)
    }
    
}

// MARK: - ServiceGuideView class

final class ServiceGuideView: UIButton {
    
    // MARK: - Properties
    
    private let link: String
    
    // MARK: - Life Cycle
    
    init(title: String, link: String) {
        self.link = link
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(TLColor.white, for: .normal)
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    @objc private func buttonTapped() {
        // button Tapped action..
    }
}
