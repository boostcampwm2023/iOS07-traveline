//
//  FilterBottomSheet.swift
//  traveline
//
//  Created by 김영인 on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class FilterBottomSheet: TLBottomSheetVC {
    
    // MARK: - UI Components
    
    private let filterListView: TLFilterListView = .init()
    
    // MARK: - Initializer
    
    init(filter: Filter) {
        super.init(
            title: filter.type.title,
            hasCompleteButton: filter.type.isMultiple,
            detentHeight: UIScreen.main.bounds.height * 0.5
        )
        
        filterListView.setupFilter(filter)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        setupLayout()
    }
    
    // MARK: - Functions
    
    override func completeAction() {
        delegate?.bottomSheetDidDisappear(data: [filterListView.selectedFilters()])
    }
}

// MARK: - Setup Functions

private extension FilterBottomSheet {
    func setupAttributes() {
        filterListView.delegate = self
    }
    
    func setupLayout() {
        main.addSubview(filterListView)
        
        filterListView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filterListView.topAnchor.constraint(equalTo: main.topAnchor),
            filterListView.leadingAnchor.constraint(equalTo: main.leadingAnchor),
            filterListView.trailingAnchor.constraint(equalTo: main.trailingAnchor),
            filterListView.bottomAnchor.constraint(equalTo: main.bottomAnchor)
        ])
    }
}

// MARK: - TLFilterListViewDelegate

extension FilterBottomSheet: TLFilterListViewDelegate {
    func filtersDidSelect(_ filter: Filter) {
        delegate?.bottomSheetDidDisappear(data: [filter])
        self.dismiss(animated: true)
    }
    
    func singleFilterDidUnSelected(_ filter: Filter) {
        delegate?.bottomSheetDidDisappear(data: [filter])
    }
}

@available(iOS 17, *)
#Preview("FilterBottomSheet") {
    let view = FilterBottomSheet(
        filter: FilterSample.makeLocation()
    )
    return view
}
