//
//  FilterCVC.swift
//  traveline
//
//  Created by 김영인 on 2023/11/21.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import UIKit

import DesignSystem
import Domain

protocol FilterCVCDelegate: AnyObject {
    func filterTypeDidSelect(type: FilterType)
}

final class FilterCVC: UICollectionViewCell {
    
    static let identifier = String(describing: type(of: FilterCVC.self))
    
    // MARK: - UI Components
    
    private let filter: TLFilter = .init()
    
    // MARK: - Properties
    
    private var filterType: FilterType = .empty
    weak var delegate: FilterCVCDelegate?
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        filter.resetFilter()
        invalidateIntrinsicContentSize()
    }
    
    // MARK: - Functions
    
    func setupData(item: Filter) {
        filterType = item.type
        filter.setupFilter(text: item.type.title, isTotal: item.type == FilterType.total)
        filter.isSelected = item.isSelected
    }
    
    @objc private func filterDidTapped(_ tlFilter: TLFilter) {
        delegate?.filterTypeDidSelect(type: filterType)
    }
}

private extension FilterCVC {
    func setupAttributes() {
        filter.addTarget(self, action: #selector(filterDidTapped(_:)), for: .touchUpInside)
    }

    func setupLayout() {
        addSubview(filter)
        filter.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filter.topAnchor.constraint(equalTo: topAnchor),
            filter.leadingAnchor.constraint(equalTo: leadingAnchor),
            filter.trailingAnchor.constraint(equalTo: trailingAnchor),
            filter.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
