//
//  TLFilterListView.swift
//  traveline
//
//  Created by 김영인 on 2023/11/24.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

protocol TLFilterListViewDelegate: AnyObject {
    func filtersDidSelect(_ filter: Filter)
    func singleFilterDidUnSelected(_ filter: Filter)
}

final class TLFilterListView: UIView {
    
    private enum Metric {
        static let height: CGFloat = 54
    }
    
    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = TLColor.black
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = TLColor.black
        return stackView
    }()
    
    // MARK: - Properties
    
    private var filter: Filter = .emtpy
    private var filterButtons: [TLFilterDetailButton] = []
    
    weak var delegate: TLFilterListViewDelegate?
    
    // MARK: - Initialzier
    
    init() {
        super.init(frame: .zero)
        
        setupAttributes()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    @objc private func detailButtonDidTapped(_ button: TLFilterDetailButton) {
        button.isSelected.toggle()
        if !filter.type.isMultiple {
            if button.isSelected {
                delegate?.filtersDidSelect(Filter(type: filter.type, selected: [button.title]))
            } else {
                delegate?.singleFilterDidUnSelected(Filter(type: filter.type, selected: []))
            }
        }
    }
    
    func setupFilter(_ filter: Filter) {
        self.filter = filter
        setupLayout(filter.type.detailFilters)
        filterButtons.forEach { $0.isSelected = filter.selected.contains($0.title) }
    }
    
    func selectedFilters() -> Filter {
        Filter(type: filter.type, selected: selectedFilterTitles())
    }
    
    private func selectedFilterTitles() -> [String] {
        filterButtons.filter { $0.isSelected }.map { $0.title }
    }
}

// MARK: - Setup Functions

private extension TLFilterListView {
    func setupAttributes() {
        backgroundColor = TLColor.black
    }
    
    func setupLayout(_ filters: [String]) {
        [
            scrollView,
            filterStackView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        filters.forEach { filter in
            let button = makeDetailButton(text: filter)
            filterStackView.addArrangedSubview(button)
            filterButtons.append(button)
        }
        scrollView.addSubview(filterStackView)
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            filterStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            filterStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            filterStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            filterStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    func makeDetailButton(text: String) -> TLFilterDetailButton {
        let button: TLFilterDetailButton = .init(title: text)
        button.addTarget(self, action: #selector(detailButtonDidTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            button.heightAnchor.constraint(equalToConstant: Metric.height)
        ])
        
        return button
    }
}

@available(iOS 17, *)
#Preview("TLFilterListView") {
    let view = TLFilterListView()
    view.setupFilter(FilterSample.makeLocation())
    return view
}
