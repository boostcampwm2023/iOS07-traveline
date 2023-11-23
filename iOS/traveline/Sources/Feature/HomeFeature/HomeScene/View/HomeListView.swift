//
//  HomeListView.swift
//  traveline
//
//  Created by 김영인 on 2023/11/20.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class HomeListView: UIView {
    
    private enum Metric {
        enum Filter {
            static let spacing: CGFloat = 8
            static let topInset: CGFloat = 12
            static let leftRightInset: CGFloat = 16
            static let width: CGFloat = 95
            static let height: CGFloat = 36
        }
        
        enum TravelList {
            static let spacing: CGFloat = 12
            static let topBottomInset: CGFloat = 24
            static let leftRightInset: CGFloat = 16
            static let height: CGFloat = 140
        }
    }
    
    private enum HomeSection: Int {
        case filter
        case travelList
    }
    
    private enum HomeItem: Hashable {
        case filterItem(Filter)
        case travelListItem(TravelListInfo)
    }
    
    // MARK: - UI Components
    
    private lazy var homeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeLayout()
        )
        collectionView.register(TLListCVC.self, forCellWithReuseIdentifier: TLListCVC.identifier)
        collectionView.register(FilterCVC.self, forCellWithReuseIdentifier: FilterCVC.identifier)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Properties
    
    private typealias DataSource = UICollectionViewDiffableDataSource<HomeSection, HomeItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>
    
    private var dataSource: DataSource!
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        
        setupLayout()
        makeDataSource()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Functions
    
    private func makeDataSource() {
        dataSource = DataSource(collectionView: homeCollectionView) { collectionView, indexPath, itemIdentifier in
            
            let section = HomeSection(rawValue: indexPath.section)
            
            var item: Any
            switch itemIdentifier {
            case let .filterItem(value):
                item = value
            case let .travelListItem(value):
                item = value
            }
            
            switch section {
            case .filter:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FilterCVC.identifier,
                    for: indexPath
                ) as? FilterCVC else { return UICollectionViewCell() }
                cell.setupData(item: item as? Filter ?? .empty)
                return cell
            case .travelList:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TLListCVC.identifier,
                    for: indexPath
                ) as? TLListCVC else { return UICollectionViewCell() }
                cell.setupData(item: item as? TravelListInfo ?? TravelListSample.makeInfo())
                return cell
            default:
                return UICollectionViewCell()
            }
        }
        
        homeCollectionView.dataSource = dataSource
    }
    
    private func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] idx, _ in
            switch idx {
            case 0:
                self?.makeFilterSection()
            default:
                self?.makeTravelListSection()
            }
        }
        
        return layout
    }
    
    private func makeFilterSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(
            widthDimension: .estimated(Metric.Filter.width),
            heightDimension: .estimated(Metric.Filter.height)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = Metric.Filter.spacing
        section.contentInsets = .init(
            top: Metric.Filter.topInset,
            leading: Metric.Filter.leftRightInset,
            bottom: 0,
            trailing: Metric.Filter.leftRightInset
        )
        
        return section
    }
    
    private func makeTravelListSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Metric.TravelList.height)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(
            top: Metric.TravelList.topBottomInset,
            leading: Metric.TravelList.leftRightInset,
            bottom: Metric.TravelList.topBottomInset,
            trailing: Metric.TravelList.leftRightInset
        )
        section.interGroupSpacing = Metric.TravelList.spacing
        
        return section
    }
    
    func setupData(filterList: FilterList, travelList: TravelList) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
        snapshot.appendSections([.filter, .travelList])
        
        filterList.forEach { snapshot.appendItems([.filterItem($0)], toSection: .filter) }
        travelList.forEach { snapshot.appendItems([.travelListItem($0)], toSection: .travelList) }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Setup Functions

extension HomeListView {
    private func setupLayout() {
        addSubviews(homeCollectionView)
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            homeCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            homeCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            homeCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            homeCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

@available(iOS 17, *)
#Preview("HomeListView") {
    let homeListView = HomeListView()
    homeListView.setupData(
        filterList: FilterType.allCases.map {
            Filter(type: $0, isSelected: false)
        },
        travelList: TravelListSample.make()
    )
    return homeListView
}