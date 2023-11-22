//
//  FilterCVC.swift
//  traveline
//
//  Created by 김영인 on 2023/11/21.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class FilterCVC: UICollectionViewCell {
    
    static let identifier = String(describing: type(of: FilterCVC.self))
    
    private let filter: TLFilter = .init(filterType: .empty)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
    }
    
    override func prepareForReuse() {
        filter.resetFilter()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(item: Filter) {
        filter.updateFilter(type: item.type)
        filter.isSelected = item.isSelected
    }
    
    @objc private func filterDidTapped(_ tlFilter: TLFilter) {
        // TODO: - 필터 바텀시트 선택된 후 필터 버튼 토글하는 로직으로 수정
        tlFilter.isSelected.toggle()
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
