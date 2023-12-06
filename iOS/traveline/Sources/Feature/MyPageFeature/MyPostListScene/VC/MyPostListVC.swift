//
//  MyPostListVC.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/27.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import UIKit

final class MyPostListVC: UIViewController {
    
    private enum Metric {
        enum TravelList {
            static let spacing: CGFloat = 12
            static let topBottomInset: CGFloat = 24
            static let leftRightInset: CGFloat = 16
            static let height: CGFloat = 140
        }
    }
    
    private enum Constants {
        static let title: String = "traveline"
        static let searchTravel: String = "여행 검색"
        static let navigationTitle: String = "내가 작성한 글 목록"
    }
    
    private enum Section: CaseIterable {
        case travels
    }
    
    // MARK: - UI Components
    
    private lazy var tlNavigationBar: TLNavigationBar = .init(vc: self)
    
    private let myPostListView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = TLColor.black
        view.register(cell: TLListCVC.self)
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    // MARK: - Properties
    
    private var cancellables: Set<AnyCancellable> = .init()
    private let viewModel: MyPostListViewModel
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, TravelListInfo>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TravelListInfo>
    
    private var dataSource: DataSource?
    
    // MARK: - Initialize
    
    init(viewModel: MyPostListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupAttributes()
        setupLayout()
        setupDataSource()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.sendAction(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Functions
    
    private func collectionLayout() -> UICollectionViewCompositionalLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(Metric.TravelList.height)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: size,
            repeatingSubitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: Metric.TravelList.topBottomInset,
            leading: Metric.TravelList.leftRightInset,
            bottom: Metric.TravelList.topBottomInset,
            trailing: Metric.TravelList.leftRightInset
        )
        section.interGroupSpacing = Metric.TravelList.spacing
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Setup Functions

private extension MyPostListVC {
    func setupAttributes() {
        myPostListView.collectionViewLayout = collectionLayout()
        myPostListView.delegate = self
        
        tlNavigationBar.setupTitle(to: Constants.navigationTitle)
        view.backgroundColor = TLColor.black
    }
    
    private func setupDataSource() {
        dataSource = DataSource(collectionView: myPostListView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeue(cell: TLListCVC.self, for: indexPath)
            cell.setupData(item: itemIdentifier)
            
            return cell
        }
        
        myPostListView.dataSource = dataSource
    }
    
    func setupLayout() {
        view.addSubviews(tlNavigationBar, myPostListView)
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tlNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tlNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tlNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tlNavigationBar.heightAnchor.constraint(equalToConstant: BaseMetric.tlheight),
            myPostListView.topAnchor.constraint(equalTo: tlNavigationBar.bottomAnchor),
            myPostListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myPostListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myPostListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bind() {
        viewModel.$state
            .map(\.travelList)
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, list in
                var snapshot = Snapshot()
                snapshot.appendSections([.travels])
                snapshot.appendItems(list, toSection: .travels)
                
                owner.dataSource?.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: - extension UICollectionViewDelegate

extension MyPostListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let timelineVC = VCFactory.makeTimelineVC(id: .empty)
        self.navigationController?.pushViewController(timelineVC, animated: true)
    }
}
