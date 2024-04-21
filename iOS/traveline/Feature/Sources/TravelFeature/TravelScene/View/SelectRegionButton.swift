//
//  SelectRegionButton.swift
//  traveline
//
//  Created by 김태현 on 2023/11/18.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

import DesignSystem

final class SelectRegionButton: UIButton {
    
    // MARK: - Initialize
    
    init() {
        super.init(frame: .zero)
        
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    /// 선택되었을 때 타이틀 변경 (지역 선택 -> 부산광역시)
    func setSelectedTitle(_ title: String) {
        let attrTitle = NSMutableAttributedString(
            string: title,
            attributes: [
                .foregroundColor: TLColor.white,
                .font: TLFont.subtitle2.font
            ]
        )
        setAttributedTitle(attrTitle, for: .normal)
    }
    
}

// MARK: - Setup Functions

private extension SelectRegionButton {
    func setupAttributes() {
        var config = UIButton.Configuration.plain()
        var attrTitle = AttributedString("지역 선택 *")
        
        attrTitle.font = TLFont.subtitle2.font
        attrTitle.foregroundColor = TLColor.disabledGray
        
        config.attributedTitle = attrTitle
        config.image = TLImage.Travel.location
        config.imagePadding = 12.0
        config.contentInsets = .zero
        
        configuration = config
    }
}
