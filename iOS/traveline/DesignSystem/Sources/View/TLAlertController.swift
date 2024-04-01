//
//  TLAlertController.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/19.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

public final class TLAlertController: UIAlertController {
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
    }
    
    // MARK: - Functions
    
    public override func addAction(_ action: UIAlertAction) {
        switch action.style {
        case .cancel:
            action.setValue(TLColor.gray, forKey: "titleTextColor")
        case .default:
            action.setValue(TLColor.main, forKey: "titleTextColor")
        case .destructive:
            action.setValue(TLColor.error, forKey: "titleTextColor")
        default: break
        }
        
        super.addAction(action)
    }
    
    public func addActions(_ actions: [UIAlertAction]) {
        actions.forEach {
            self.addAction($0)
        }
    }
    
    private func attributedString(from font: TLFont) -> [NSAttributedString.Key: Any] {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = font.lineHeight
        paragraph.alignment = .center
        
        return [
            NSAttributedString.Key.font: font.font,
            NSAttributedString.Key.foregroundColor: TLColor.white,
            NSAttributedString.Key.kern: font.letterSpacing,
            NSAttributedString.Key.paragraphStyle: paragraph
        ] as [NSAttributedString.Key: Any]
    }
}

// MARK: - Setup Functions

extension TLAlertController {
    
    private func setupAttributes() {
        setAlertBackgroundColor()
        setAlertTitleFont()
        setAlertMessageFont()
    }
    
    private func setAlertBackgroundColor() {
        view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = TLColor.darkGray
    }
    
    private func setAlertTitleFont() {
        let titleAttributes = attributedString(from: .subtitle2)
        let titleString = NSAttributedString(string: title ?? "", attributes: titleAttributes)
        
        self.setValue(titleString, forKey: "attributedTitle")
        
    }
    
    private func setAlertMessageFont() {
        let messageAttributes = attributedString(from: .body3)
        let messageString = NSAttributedString(string: message ?? "", attributes: messageAttributes)
        
        self.setValue(messageString, forKey: "attributedMessage")
    }
    
}
