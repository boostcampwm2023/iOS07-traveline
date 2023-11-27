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

protocol HomeViewDelegate: AnyObject {
    func sideMenuTapped()
}

final class HomeVC: UIViewController {
    
    private enum Metric {
        static let topInset: CGFloat = 12
        
        enum Button {
            static let trailingInset: CGFloat = 24
            static let bottomInset: CGFloat = 10
        }
    }
    
    private enum Constants {
        static let title: String = "traveline"
        static let searchTravel: String = "여행 검색"
    }
    
    // MARK: - UI Components
    
    private let searchController = TLSearchController.init(placeholder: Constants.searchTravel)
    private let homeListView: HomeListView = .init()
    private let homeSearchView: HomeSearchView = .init()
    private let createTravelButton: TLFloatingButton = .init(style: .create)
    
    // MARK: - Properties
    
    private var cancellables: Set<AnyCancellable> = .init()
    private let viewModel: HomeViewModel
    weak var delegate: HomeViewDelegate?
    
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
    
    @objc private func createTravelButtonDidTapped(_ button: TLFloatingButton) {
        let travelVC = TravelVC()
        navigationController?.pushViewController(travelVC, animated: true)
    }
    
    @objc private func menuButtonTapped() {
        delegate?.sideMenuTapped()
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: TLImage.Home.menu,
            style: .plain,
            target: self,
            action: #selector(menuButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = TLColor.white
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: TLColor.white,
            .font: TLFont.subtitle1.font
        ]
        
        homeSearchView.isHidden = true
        
        createTravelButton.addTarget(
            self,
            action: #selector(createTravelButtonDidTapped(_:)),
            for: .touchUpInside
        )
        
        // TODO: - 서버 연동 후 수정
        homeListView.setupData(
            filterList: FilterType.allCases.map {
                Filter(type: $0, selected: [])
            },
            travelList: TravelListSample.make()
        )
        
        let backBarButtonItem = UIBarButtonItem()
        backBarButtonItem.tintColor = TLColor.white
        self.navigationItem.backBarButtonItem = backBarButtonItem
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
            homeSearchView,
            createTravelButton
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
            homeSearchView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            createTravelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.Button.trailingInset),
            createTravelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Metric.Button.bottomInset)
        ])
    }
    
    func bind() {
        homeListView.didSelectHomeList
            .sink { [weak owner = self] _ in
                guard let owner else { return }
                let timelineVC = TimelineVC()
                owner.navigationController?.pushViewController(
                    timelineVC,
                    animated: true
                )
            }
            .store(in: &cancellables)
        
        homeListView.didSelectFilterType
            .sink { [weak owner = self] type in
                guard let owner else { return }
                owner.viewModel.sendAction(.startFilter(type))
            }
            .store(in: &cancellables)
        
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
        
        viewModel.$state
            .filter { $0.homeViewType == .home }
            .dropFirst()
            .compactMap(\.curFilter)
            .filter { $0 != .emtpy }
            .sink { [weak owner = self] filter in
                guard let owner else { return }
                let filterVC = FilterBottomSheet(filter: filter)
                filterVC.delegate = owner
                owner.present(filterVC, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.$state
            .filter { $0.homeViewType == .home }
            .map(\.filters)
            .removeDuplicates()
            .sink { [weak owner = self] filters in
                guard let owner else { return }
                owner.homeListView.setupData(
                    filterList: filters.map { $0.value }.sorted { $0.type.id < $1.type.id },
                    travelList: TravelListSample.make()
                )
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

// MARK: - TLBottomSheetDelegate

extension HomeVC: TLBottomSheetDelegate {
    func bottomSheetDidDisappear(data: Any) {     
        guard let filters = data as? [Filter] else { return }
        viewModel.sendAction(.addFilter(filters))
    }
}

@available(iOS 17, *)
#Preview("HomeVC") {
    let homeViewModel = HomeViewModel()
    let homeVC = HomeVC(viewModel: homeViewModel)
    let homeNV = UINavigationController(rootViewController: homeVC)
    return homeNV
}
