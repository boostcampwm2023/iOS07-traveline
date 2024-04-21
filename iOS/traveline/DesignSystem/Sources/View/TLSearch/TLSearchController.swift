//
//  TLSearchController.swift
//  traveline
//
//  Created by 김영인 on 2023/11/15.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

public final class TLSearchController: UISearchController {
    
    private enum Constants {
        static let cancel: String = "취소"
        static let cancelButtonTextKey: String = "cancelButtonText"
    }
    
    private let placeholder: String
    
    public init(
        placeholder: String,
        searchResultsController: UIViewController? = nil
    ) {
        self.placeholder = placeholder
        super.init(nibName: nil, bundle: nil)
        
        setupAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TLSearchController {
    func setupAttributes() {
        searchBar.placeholder = placeholder
        searchBar.barTintColor = TLColor.backgroundGray
        searchBar.tintColor = TLColor.main
        searchBar.barStyle = .black

        searchBar.searchTextField.defaultTextAttributes = [
            .foregroundColor: TLColor.gray,
            .font: TLFont.subtitle2.font
        ]
        
        searchBar.setValue(Constants.cancel, forKey: Constants.cancelButtonTextKey)
        searchBar.searchTextField.font = TLFont.subtitle2.font
        searchBar.searchTextField.leftView?.tintColor = TLColor.gray
    }
}
