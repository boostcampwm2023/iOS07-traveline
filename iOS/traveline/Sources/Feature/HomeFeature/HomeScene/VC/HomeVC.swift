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
    private let homeSearchView = HomeSearchView.init()
    
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
    
    // MARK: - Functions
    
    func setupSearchView() {
        view.addSubview(homeSearchView)
        homeSearchView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            homeSearchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeSearchView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeSearchView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeSearchView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        
        homeListView.setupData(
            filterList: FilterType.allCases.map {
                Filter(type: $0, isSelected: false)
            },
            travelList: TravelListSample.make()
        )
    }
    
    func setupLayout() {
        view.addSubviews(homeListView)
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            homeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func bind() {
        viewModel.$state
            .map(\.isSearching)
            .removeDuplicates()
            .filter { $0 }
            .sink { [weak owner = self] _ in
                guard let owner else { return }
                owner.setupSearchView()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UISearchBarDelegate

extension HomeVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.searchTextField.text else { return }
        viewModel.sendAction(.startSearch(text))
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: - 검색결과
        guard let text = searchBar.text else { return }
        viewModel.sendAction(.searchDone(text))
        homeSearchView.removeFromSuperview()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // TODO: - 전체 리스트
        viewModel.sendAction(.cancelSearch)
        homeSearchView.removeFromSuperview()
    }
}

@available(iOS 17, *)
#Preview("HomeVC") {
    let homeViewModel = HomeViewModel()
    let homeVC = HomeVC(viewModel: homeViewModel)
    let homeNV = UINavigationController(rootViewController: homeVC)
    return homeNV
}
