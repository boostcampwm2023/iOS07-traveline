//
//  TimelineDateHeaderView.swift
//  traveline
//
//  Created by 김태현 on 11/22/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

protocol TimelineDateHeaderDelegate: AnyObject {
    func goToMapView()
    func changeDay(to index: Int)
}

final class TimelineDateHeaderView: UICollectionReusableView {
    
    private enum Metric {
        static let verticalInset: CGFloat = 16.0
        static let horizontalInset: CGFloat = 16.0
        static let borderWidth: CGFloat = 1.0
        static let indicatorHeight: CGFloat = 36.0
        static let indicatorWidth: CGFloat = 60.0
        static let spacing: CGFloat = 8.0
    }
    
    private enum TimelineHeaderSection {
        case days
    }
    
    // MARK: - UI Components
    
    private lazy var dateCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout
        )
        
        collectionView.register(cell: DateIndicatorCVC.self)
        collectionView.backgroundColor = TLColor.black
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        
        return collectionView
    }()
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = Metric.spacing
        layout.sectionInset = .init(
            top: .zero,
            left: Metric.horizontalInset,
            bottom: .zero,
            right: Metric.horizontalInset
        )
        layout.estimatedItemSize = .init(
            width: Metric.indicatorWidth,
            height: Metric.indicatorHeight
        )
        
        return layout
    }()
    
    private let borderView: UIView = {
        let view = UIView()
        
        view.backgroundColor = TLColor.lineGray
        
        return view
    }()
    
    private let dayLabel: TLLabel = .init(
        font: .heading1,
        color: TLColor.white
    )
    
    private let mapViewButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var attrTitle = AttributedString("지도로 보기")
        
        attrTitle.font = TLFont.body2.font
        attrTitle.foregroundColor = TLColor.gray
        
        config.attributedTitle = attrTitle
        config.image = TLImage.Travel.map
        config.imagePadding = 4.0
        config.contentInsets = .zero
        
        button.configuration = config
        
        return button
    }()
    
    // MARK: - Properties
    
    private typealias DataSource = UICollectionViewDiffableDataSource<TimelineHeaderSection, String>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<TimelineHeaderSection, String>
    
    private var dataSource: DataSource!
    weak var delegate: TimelineDateHeaderDelegate?
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupAttributes()
        setupLayout()
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func setData(info: TimelineTravelInfo) {
        var snapshot = Snapshot()
        snapshot.appendSections([.days])
        snapshot.appendItems(info.days)
        
        dataSource.apply(snapshot)
        
        dateCollectionView.selectItem(
            at: .init(item: info.day - 1, section: 0),
            animated: true,
            scrollPosition: .left
        )
        dayLabel.setText(to: "Day \(info.day)")
    }
    
    @objc private func mapViewButtonPressed() {
        delegate?.goToMapView()
    }

}

// MARK: - Setup Functions

private extension TimelineDateHeaderView {
    func setupAttributes() {
        backgroundColor = TLColor.black
        
        mapViewButton.addTarget(self, action: #selector(mapViewButtonPressed), for: .touchUpInside)
    }
    
    func setupLayout() {
        addSubviews(
            dateCollectionView,
            borderView,
            dayLabel,
            mapViewButton
        )
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            dateCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: Metric.verticalInset),
            dateCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateCollectionView.heightAnchor.constraint(equalToConstant: Metric.indicatorHeight),
            
            borderView.bottomAnchor.constraint(equalTo: dateCollectionView.bottomAnchor),
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            borderView.heightAnchor.constraint(equalToConstant: Metric.borderWidth),
            
            dayLabel.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: Metric.verticalInset),
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.horizontalInset),
            
            mapViewButton.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor),
            mapViewButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metric.verticalInset)
        ])
    }
    
    func setupDataSource() {
        dataSource = DataSource(collectionView: dateCollectionView) { collectionView, indexPath, day in
            let cell = collectionView.dequeue(cell: DateIndicatorCVC.self, for: indexPath)
            cell.setDate(day)
            return cell
        }
        
        dateCollectionView.dataSource = dataSource
    }
}

// MARK: - UICollectionView Delegate, DataSource

extension TimelineDateHeaderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = indexPath.row + 1
        delegate?.changeDay(to: day)
    }
}

@available(iOS 17, *)
#Preview {
    let view = TimelineDateHeaderView()
    return view
}
