//
//  HomeSearchView.swift
//  traveline
//
//  Created by 김영인 on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

enum SearchViewType {
    case recent
}

final class HomeSearchView: UIView {
    
    // MARK: - UI Components
    
    private lazy var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = TLColor.main
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        
        setupAttribute()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
}

// MARK: - Setup Functions

private extension HomeSearchView {
    func setupAttribute() {
        
    }
    
    func setupLayout() {
        addSubviews(searchTableView)
        
        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: topAnchor),
            searchTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
