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
        viewModel.sendAction(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        viewModel.sendAction(.viewWillAppear)
    }
    
    // MARK: - Functions
    
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
        
        let backBarButtonItem = UIBarButtonItem(title: Literal.empty, style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .clear
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        homeSearchView.isHidden = true
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
        bindListView()
        bindSearchView()
        
        createTravelButton
            .tapPublisher
            .withUnretained(self)
            .sink { owner, _ in
                owner.viewModel.sendAction(.createTravel)
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.travelList)
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, list in
                owner.homeListView.setupData(list: list)
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.searchList)
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, list in
                owner.homeSearchView.setupData(list: list)
            }
            .store(in: &cancellables)
        
        viewModel.state
            .filter { $0.isSearching }
            .map(\.homeViewType)
            .withUnretained(self)
            .sink { owner, type in
                let type: SearchViewType = (type == .recent) ? .recent : .related
                owner.homeSearchView.isHidden = false
                owner.homeSearchView.makeLayout(type: type)
                owner.createTravelButton.isHidden = true
            }
            .store(in: &cancellables)
        
        viewModel.state
            .filter { !$0.isSearching }
            .compactMap(\.curFilter)
            .filter { $0 != .emtpy }
            .withUnretained(self)
            .sink { owner, filter in
                let filterVC = FilterBottomSheet(filter: filter)
                filterVC.delegate = owner
                owner.present(filterVC, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.state
            .filter { $0.homeViewType == .home }
            .map(\.homeFilters)
            .withUnretained(self)
            .sink { owner, filters in
                owner.homeListView.setupData(list: .sortFilters(filters))
                owner.createTravelButton.isHidden = false
            }
            .store(in: &cancellables)
        
        viewModel.state
            .filter { $0.homeViewType == .home }
            .map(\.homeFilters)
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, filters in
                owner.viewModel.sendAction(.filterChanged(filters))
            }
            .store(in: &cancellables)
        
        viewModel.state
            .filter { $0.homeViewType == .result }
            .map(\.resultFilters)
            .withUnretained(self)
            .sink { owner, filters in
                owner.homeListView.setupData(list: .sortFilters(filters))
            }
            .store(in: &cancellables)
        
        viewModel.state
            .filter { $0.homeViewType == .result }
            .map(\.resultFilters)
            .removeDuplicates()
            .withUnretained(self)
            .sink { owner, filters in
                owner.viewModel.sendAction(.filterChanged(filters))
            }
            .store(in: &cancellables)
        
        viewModel.state
            .map(\.moveToTravelWriting)
            .filter { $0 }
            .withUnretained(self)
            .sink { owner, _ in
                let travelVC = VCFactory.makeTravelVC()
                owner.navigationController?.pushViewController(travelVC, animated: true)
            }
            .store(in: &cancellables)
    }
    
    func bindListView() {
        homeListView.didSelectHomeList
            .withUnretained(self)
            .sink { owner, _  in
                let timelineVC = VCFactory.makeTimelineVC(id: .empty)
                owner.navigationController?.pushViewController(
                    timelineVC,
                    animated: true
                )
            }
            .store(in: &cancellables)
        
        homeListView.didSelectFilterType
            .withUnretained(self)
            .sink { owner, type in
                owner.viewModel.sendAction(.startFilter(type))
            }
            .store(in: &cancellables)
    }
    
    func bindSearchView() {
        homeSearchView.didSelectKeyword
            .withUnretained(self)
            .sink { owner, keyword in
                owner.viewModel.sendAction(.searchDone(keyword))
                owner.homeSearchView.isHidden = true
                owner.searchController.searchBar.text = keyword
                owner.searchController.searchBar.resignFirstResponder()
            }
            .store(in: &cancellables)
        
        homeSearchView.didDeleteKeyword
            .withUnretained(self)
            .sink { owner, keyword in
                owner.viewModel.sendAction(.deleteKeyword(keyword))
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
    let homeVC = VCFactory.makeHomeVC()
    let homeNV = UINavigationController(rootViewController: homeVC)
    return homeNV
}
