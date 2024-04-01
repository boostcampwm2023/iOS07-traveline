//
//  SearchCVC.swift
//  traveline
//
//  Created by 김영인 on 2023/11/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import UIKit

import DesignSystem
import Domain

protocol SearchCVCDelegate: AnyObject {
    func deleteKeyword(_ keyword: String)
}

final class SearchCVC: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let tlSearchInfoView: TLSearchInfoView = .init()
    
    // MARK: - Properties
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    weak var delegate: SearchCVCDelegate?
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func setupData(item: SearchKeyword) {
        tlSearchInfoView.setupDate(
            title: item.title,
            searchedKeyword: item.searchedKeyword,
            isCloseButton: item.type == .related,
            isSearchIcon: item.type == .recent
        )
    }
}

// MARK: - Setup Functions

private extension SearchCVC {
    func setupAttributes() {
        tlSearchInfoView.closeButton
            .tapPublisher
            .withUnretained(self)
            .sink { owner, _ in
                if let keyword = owner.tlSearchInfoView.keyword {
                    owner.delegate?.deleteKeyword(keyword)
                }
            }
            .store(in: &cancellables)
    }
    
    func setupLayout() {
        addSubview(tlSearchInfoView)
        tlSearchInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tlSearchInfoView.topAnchor.constraint(equalTo: topAnchor),
            tlSearchInfoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tlSearchInfoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tlSearchInfoView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
