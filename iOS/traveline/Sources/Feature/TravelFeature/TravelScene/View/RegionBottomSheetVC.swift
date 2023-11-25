//
//  RegionBottomSheetVC.swift
//  traveline
//
//  Created by 김태현 on 11/25/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class RegionBottomSheetVC: TLBottomSheetVC {
    
    // MARK: - UI Components
    
    private lazy var regionCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        
        collectionView.backgroundColor = TLColor.black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: RegionCVC.self)
        
        return collectionView
    }()
    
    // MARK: - Properties
    
    private let travelRegions: [String] = TravelRegion.allCases.map { $0.name }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
}

// MARK: - Setup Functions

private extension RegionBottomSheetVC {
    func setupLayout() {
        main.addSubview(regionCollectionView)
        main.isUserInteractionEnabled = true
        regionCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            regionCollectionView.topAnchor.constraint(equalTo: main.topAnchor),
            regionCollectionView.leadingAnchor.constraint(equalTo: main.leadingAnchor),
            regionCollectionView.trailingAnchor.constraint(equalTo: main.trailingAnchor),
            regionCollectionView.bottomAnchor.constraint(equalTo: main.bottomAnchor)
        ])
    }
    
    func makeLayout() -> UICollectionViewCompositionalLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(47.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - UICollectionView Delegate, DataSource

extension RegionBottomSheetVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedRegion = travelRegions[indexPath.row]
        delegate?.bottomSheetDidDisappear(data: selectedRegion)
        dismiss(animated: true)
    }
}

extension RegionBottomSheetVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        travelRegions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: RegionCVC.self, for: indexPath)
        cell.setRegion(travelRegions[indexPath.row])
        return cell
    }
}
