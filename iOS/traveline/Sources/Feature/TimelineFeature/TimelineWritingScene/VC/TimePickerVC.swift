//
//  TimePickerVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class TimePickerVC: UIViewController {
    
    let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        
        return picker
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func timeFormat(date: Date) -> String {
        let formmater = DateFormatter()
        formmater.locale = Locale(identifier: "ko_KR")
        formmater.dateFormat = "a hh:mm"
        let result = formmater.string(from: date)
        return result
    }
    
    func time() -> String {
        return timeFormat(date: timePicker.date)
    }
    
}

// MARK: - Setup Functions

private extension TimePickerVC {
    
    func setupAttributes() {
        self.view = timePicker
    }
}
