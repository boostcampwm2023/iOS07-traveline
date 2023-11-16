//
//  TLLabel.swift
//  traveline
//
//  Created by 김영인 on 2023/11/15.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class TLLabel: UILabel {

    private var travelineFont: TLFont
    private let alignment: NSTextAlignment
    private var travelineColor: UIColor
    private var labelText: String

    // MARK: - Initialize
    
    init(
        frame: CGRect = .zero,
        font: TLFont,
        text: String,
        alignment: NSTextAlignment = .left,
        color: UIColor
    ) {
        self.travelineFont = font
        self.alignment = alignment
        self.travelineColor = color
        self.labelText = text

        super.init(frame: frame)

        setupAttributes()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions
    
    private func setupAttributes() {
        let attributedString = NSMutableAttributedString(string: labelText)
        let range = (labelText as NSString).range(of: labelText)

        attributedString.addAttribute(
            .font,
            value: travelineFont.font,
            range: range
        )

        attributedString.addAttribute(
            .foregroundColor,
            value: travelineColor,
            range: range
        )

        attributedString.addAttribute(
            .kern,
            value: travelineFont.letterSpacing,
            range: range
        )

        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = travelineFont.lineHeight
        paragraph.alignment = alignment

        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraph,
            range: range
        )

        attributedText = attributedString
    }

    func setText(to text: String) {
        labelText = text
        setupAttributes()
    }
    
    func setColor(to color: UIColor) {
        travelineColor = color
        setupAttributes()
    }
    
    func setFont(to font: TLFont) {
        travelineFont = font
        setupAttributes()
    }
    
}
