//
//  ExampleBottomSheet.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/16.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class ExampleBottomSheet: TLBottomSheet {
    
    // MARK: - UI Components
    
    let textFiled: UITextField = .init()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        setupLayout()
    }
    
    // MARK: - Functions
    
    override func doneAction() {
        let text = textFiled.text
        delegate?.bottomSheet(data: text)
    }
}

// MARK: - Setup Functions

extension ExampleBottomSheet {
    func setupAttributes() {
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        textFiled.backgroundColor = .blue
    }
    
    func setupLayout() {
        main.addSubview(textFiled)
        NSLayoutConstraint.activate([
            textFiled.leadingAnchor.constraint(equalTo: main.leadingAnchor),
            textFiled.trailingAnchor.constraint(equalTo: main.trailingAnchor),
            textFiled.centerXAnchor.constraint(equalTo: main.centerXAnchor),
            textFiled.centerYAnchor.constraint(equalTo: main.centerYAnchor)
        ])
    }
}
