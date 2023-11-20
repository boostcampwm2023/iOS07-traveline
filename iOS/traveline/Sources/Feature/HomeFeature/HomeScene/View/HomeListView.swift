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
        static let spacing: CGFloat = 12
        static let sectionInset: CGFloat = 24
        static let inset: CGFloat = 16
        static let width: CGFloat = UIScreen.main.bounds.width - 32
        static let height: CGFloat = 140
    }
    
    private enum HomeListType {
        case travelInfo
    }
    
    // MARK: - UI Components
    
    private lazy var homeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: tlFlowLayout)
        collectionView.register(TLListCVC.self, forCellWithReuseIdentifier: TLListCVC.identifier)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let tlFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = Metric.spacing
        layout.sectionInset = .init(top: Metric.sectionInset, left: 0, bottom: Metric.sectionInset, right: 0)
        layout.estimatedItemSize = .init(width: Metric.width, height: Metric.height)
        return layout
    }()
    
    // MARK: - Properties
    
    private var dataSource: UICollectionViewDiffableDataSource<HomeListType, TravelListInfo>!
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        
        setupLayout()
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Functions
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HomeListType, TravelListInfo>(
            collectionView: self.homeCollectionView
        ) { (collectionView, indexPath, travelInfo) -> TLListCVC? in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TLListCVC.identifier,
                for: indexPath
            ) as? TLListCVC else {
                return nil
            }
            cell.config(item: travelInfo)
            return cell
        }
    }
    
    func setupData(items: TravelList) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeListType, TravelListInfo>()
        snapshot.appendSections([.travelInfo])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

private extension HomeListView {
    func setupLayout() {
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
    homeListView.setupData(items: TravelListSample.make())
    return homeListView
}
