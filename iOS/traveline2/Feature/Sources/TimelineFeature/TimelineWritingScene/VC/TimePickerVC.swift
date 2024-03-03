//
//  TimePickerVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class TimePickerVC: UIViewController {
    
    // MARK: - UI Components
    
    private let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.locale = Locale(identifier: "ko_KR")
        picker.preferredDatePickerStyle = .wheels
        
        return picker
    }()
    
    // MARK: - Properties
    var time: String {
        return timeFormat(date: timePicker.date)
    }
    
    // MARK: - Initialize
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func timeFormat(date: Date) -> String {
        let formmater = DateFormatter()
        formmater.locale = Locale(identifier: "ko_KR")
        formmater.dateFormat = "a hh:mm"
        let result = formmater.string(from: date)
        return result
    }
    
}

// MARK: - Setup Functions

private extension TimePickerVC {
    
    func setupLayout() {
        view.addSubview(timePicker)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        
        timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
