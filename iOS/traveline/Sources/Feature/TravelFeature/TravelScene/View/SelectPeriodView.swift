//
//  SelectPeriodView.swift
//  traveline
//
//  Created by 김태현 on 11/20/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class SelectPeriodView: UIView {
    
    private enum Constants {
        static let startDateTitle: String = "출발일 *"
        static let endDateTitle: String = "도착일 *"
        static let imageHeight: CGFloat = 20.0
        static let spacing: CGFloat = 12.0
        static let radius: CGFloat = 12.0
    }
    
    // MARK: - UI Components
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = Constants.spacing
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private let timeImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = TLImage.Travel.time
        
        return imageView
    }()

    let startDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.calendar.locale = Locale(identifier: "ko_KR")
        
        return datePicker
    }()
    
    private let dashLabel: TLLabel = .init(
        font: .subtitle2,
        text: "-",
        color: TLColor.white
    )
    
    let endDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.calendar.locale = Locale(identifier: "ko_KR")
        
        return datePicker
    }()
    
    // MARK: - Initialize
    
    init() {
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
}

// MARK: - Setup Functions

private extension SelectPeriodView {
    func setupAttributes() {
        backgroundColor = .clear
    }
    
    func setupLayout() {
        addSubviews(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        [
            timeImageView,
            startDatePicker,
            dashLabel,
            endDatePicker
        ].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            timeImageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
            timeImageView.widthAnchor.constraint(equalTo: timeImageView.heightAnchor)
        ])
    }
}

@available(iOS 17, *)
#Preview {
    SelectPeriodView()
}
