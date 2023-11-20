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
        static let topInset: CGFloat = 24
    }
    
    private enum Constants {
        static let title: String = "traveline"
        static let searchTravel: String = "여행 검색"
    }
    
    // MARK: - UI Components
    
    private let searchController = TLSearchController.init(placeholder: Constants.searchTravel)
    private let homeListView: HomeListView = .init()
    
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
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        view.backgroundColor = TLColor.black
        
        navigationItem.searchController = searchController
        navigationItem.title = Constants.title
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: TLColor.white,
            .font: TLFont.subtitle1.font
        ]
        
        homeListView.setData(items: TravelListSample.make())
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
            .map(\.value)
            .sink { value in
                os_log("\(value)")
            }
            .store(in: &cancellables)
    }
}

// MARK: - UISearchResultsUpdating

extension HomeVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO: - 최근검색어 및 자동완성어
        guard let text = searchController.searchBar.searchTextField.text else { return }
        viewModel.sendAction(.searchStart(text))
    }
}

extension HomeVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: - 검색결과
        guard let text = searchBar.text else { return }
        viewModel.sendAction(.searchDone(text))
    }
}

@available(iOS 17, *)
#Preview("HomeVC") {
    let homeViewModel = HomeViewModel()
    let homeVC = HomeVC(viewModel: homeViewModel)
    let homeNV = UINavigationController(rootViewController: homeVC)
    return homeNV
}
