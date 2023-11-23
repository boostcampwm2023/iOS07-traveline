//
//  HomeVC.swift
//  traveline
//
//  Created by 김영인 on 2023/11/15.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import UIKit
import OSLog

final class HomeVC: UIViewController {
    
    private enum Metric {
        static let topInset: CGFloat = 12
    }
    
    private enum Constants {
        static let title: String = "traveline"
        static let searchTravel: String = "여행 검색"
    }
    
    // MARK: - UI Components
    
    private let searchController = TLSearchController.init(placeholder: Constants.searchTravel)
    private let homeListView: HomeListView = .init()
    private let homeSearchView: HomeSearchView = .init()
    
    // MARK: - Properties
    
    private var cancellables: Set<AnyCancellable> = .init()
    private let viewModel: HomeViewModel
    
    // MARK: - Initializer
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        setupLayout()
        bind()
    }
}

// MARK: - Setup Functions

private extension HomeVC {
    func setupAttributes() {
        searchController.searchBar.delegate = self
        
        view.backgroundColor = TLColor.black
        
        navigationItem.searchController = searchController
        navigationItem.title = Constants.title
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: TLColor.white,
            .font: TLFont.subtitle1.font
        ]
        
        homeSearchView.isHidden = true
        
        // TODO: - 서버 연동 후 수정
        homeListView.setupData(
            filterList: FilterType.allCases.map {
                Filter(type: $0, isSelected: false)
            },
            travelList: TravelListSample.make()
        )
    }
    
    // TODO: - 서버 연동 후 수정
    func testSampleData(type: SearchViewType) {
        if type == .recent {
            homeSearchView.setupData(
                list: SearchKeywordSample.makeRecentList()
            )
        } else {
            homeSearchView.setupData(
                list: SearchKeywordSample.makeRelatedList()
            )
        }
    }
    
    func setupLayout() {
        view.addSubviews(
            homeListView,
            homeSearchView
        )
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            homeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            homeSearchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeSearchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeSearchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeSearchView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func bind() {
        viewModel.$state
            .map(\.homeViewType)
            .removeDuplicates()
            .filter { $0 == .recent || $0 == .related }
            .sink { [weak owner = self] type in
                guard let owner else { return }
                let type: SearchViewType = (type == .recent) ? .recent : .related
                owner.homeSearchView.isHidden = false
                owner.homeSearchView.makeLayout(type: type)
                owner.testSampleData(type: type)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UISearchBarDelegate

extension HomeVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // 최근 검색어
        viewModel.sendAction(.startSearch)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 관련 검색어
        viewModel.sendAction(.searching(searchText))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 검색 결과
        guard let text = searchBar.text else { return }
        viewModel.sendAction(.searchDone(text))
        homeSearchView.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // 홈 리스트
        viewModel.sendAction(.cancelSearch)
        homeSearchView.isHidden = true
    }
}

@available(iOS 17, *)
#Preview("HomeVC") {
    let homeViewModel = HomeViewModel()
    let homeVC = HomeVC(viewModel: homeViewModel)
    let homeNV = UINavigationController(rootViewController: homeVC)
    return homeNV
}
