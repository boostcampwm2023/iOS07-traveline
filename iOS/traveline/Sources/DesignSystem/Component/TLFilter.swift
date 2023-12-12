//
//  TLFilter.swift
//  traveline
//
//  Created by 김영인 on 2023/11/21.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class TLFilter: UIButton {
    
    private enum Metric {
        static let leftRightInset: CGFloat = 10
        static let topBottomInset: CGFloat = 8
        static let spacing: CGFloat = 4
        static let zero: CGFloat = 0
        static let cornerRadius: CGFloat = 12
    }
    
    // MARK: - UI Components
    
    private let innerView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = TLColor.darkGray
        view.layer.cornerRadius = Metric.cornerRadius
        view.layer.borderColor = .init(gray: 0, alpha: 0)
        view.layer.borderWidth = 0.8
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.isUserInteractionEnabled = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private let filterTitleLabel: TLLabel = .init(
        font: .body3,
        color: TLColor.unselectedGray
    )
    
    private let filterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Properties
    
    private var filterType: FilterType?
    
    override var isSelected: Bool {
        didSet {
            updateFilterSelected()
        }
    }
    
    private var isTotal: Bool {
        return filterType == .total
    }
    
    private var filterImage: UIImage {
        return isTotal ? TLImage.Filter.total : TLImage.Filter.down
    }
    
    private var filterSelectedImage: UIImage {
        return isTotal ? TLImage.Filter.totalSelected : TLImage.Filter.downSelected
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func updateFilterSelected() {
        if isSelected {
            filterTitleLabel.setColor(to: TLColor.main)
            filterImageView.image = filterSelectedImage
            innerView.backgroundColor = TLColor.main.withAlphaComponent(0.24)
            innerView.layer.borderColor = TLColor.main.cgColor
        } else {
            filterTitleLabel.setColor(to: TLColor.unselectedGray)
            filterImageView.image = filterImage
            innerView.backgroundColor = TLColor.darkGray
            innerView.layer.borderColor = .init(gray: 0, alpha: 0)
        }
    }
    
    func setupFilter(type: FilterType) {
        setupAttributes(type: type)
    }
    
    func resetFilter() {
        filterTitleLabel.text = ""
        filterImageView.image = nil
        isSelected = false
    }
}

// MARK: - Setup Functions

private extension TLFilter {
    func setupAttributes(type: FilterType) {
        self.filterType = type
        filterTitleLabel.setText(to: type.title)
        filterTitleLabel.setColor(to: isSelected ? TLColor.main :  TLColor.unselectedGray)
        stackView.spacing = isTotal ? Metric.zero : Metric.spacing
        filterImageView.image = isSelected ? filterSelectedImage : filterImage
    }
    
    func setupLayout() {
        [
            innerView,
            stackView,
            filterTitleLabel,
            filterImageView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        stackView.addArrangedSubviews(filterTitleLabel, filterImageView)
        innerView.addSubview(stackView)
        addSubview(innerView)
        
        NSLayoutConstraint.activate([
            innerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            innerView.topAnchor.constraint(equalTo: topAnchor),
            innerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            innerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: innerView.leadingAnchor, constant: Metric.leftRightInset),
            stackView.topAnchor.constraint(equalTo: innerView.topAnchor, constant: Metric.topBottomInset),
            stackView.bottomAnchor.constraint(equalTo: innerView.bottomAnchor, constant: -Metric.topBottomInset),
            stackView.trailingAnchor.constraint(equalTo: innerView.trailingAnchor, constant: -Metric.leftRightInset)
        ])
    }
}

@available(iOS 17, *)
#Preview("TLFilter") {
    let tlFilter = TLFilter.init()
    tlFilter.setupFilter(type: .total)
    tlFilter.isSelected = false
    return tlFilter
}
