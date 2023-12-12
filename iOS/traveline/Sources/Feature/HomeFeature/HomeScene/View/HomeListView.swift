//
//  HomeListView.swift
//  traveline
//
//  Created by 김영인 on 2023/11/20.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
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
        collectionView.backgroundColor = TLColor.black
        collectionView.register(TLListCVC.self, forCellWithReuseIdentifier: TLListCVC.identifier)
        collectionView.register(FilterCVC.self, forCellWithReuseIdentifier: FilterCVC.identifier)
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        
        refresh.tintColor = TLColor.main
        refresh.addTarget(
            self,
            action: #selector(refreshList),
            for: .valueChanged
        )
        
        return refresh
    }()
    
    // MARK: - Properties
    
    private typealias DataSource = UICollectionViewDiffableDataSource<HomeSection, HomeItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>
    
    private var dataSource: DataSource!
    
    let didSelectHomeList: PassthroughSubject<Int, Never> = .init()
    let didSelectFilterType: PassthroughSubject<FilterType, Never> = .init()
    let didScrollToBottom: PassthroughSubject<Void, Never> = .init()
    let didRefreshHomeList: PassthroughSubject<Void, Never> = .init()
    
    private var isPaging: Bool = true
    private var cancellables: Set<AnyCancellable> = .init()
    
    var isRefreshEnabled: Bool = true {
        didSet {
            homeCollectionView.refreshControl = isRefreshEnabled ? refreshControl : nil
        }
    }
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        
        setupLayout()
        setupDataSource()
        setupSnapshot()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Functions
    
    private func setupDataSource() {
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
                cell.setupData(item: item as? Filter ?? .emtpy)
                cell.delegate = self
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
    
    func setupSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.filter, .travelList])
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func setupData(list: FilterList) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .filter))
        list.forEach { snapshot.appendItems([.filterItem($0)], toSection: .filter) }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func setupData(list: TravelList) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .travelList))
        list.forEach { snapshot.appendItems([.travelListItem($0)], toSection: .travelList) }
        
        dataSource.apply(snapshot, animatingDifferences: false)
        isPaging = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    @objc private func refreshList() {
        didRefreshHomeList.send(Void())
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

// MARK: - UICollectionViewDelegate

extension HomeListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectHomeList.send(indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height {
            if !isPaging {
                isPaging = true
                didScrollToBottom.send(Void())
            }
        }
    }
}

// MARK: - FilterCVCDelegate

extension HomeListView: FilterCVCDelegate {
    func filterTypeDidSelect(type: FilterType) {
        didSelectFilterType.send(type)
    }
}
