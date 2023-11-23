//
//  TimelineVC.swift
//  traveline
//
//  Created by 김태현 on 11/22/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

final class TimelineVC: UIViewController {
    
    private enum Metric {
        static let travelInfoEstimatedHeight: CGFloat = 170.0
    }
    
    // MARK: - UI Components
    
    private lazy var timelineCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        
        collectionView.register(cell: TravelInfoCVC.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = TLColor.black
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
        
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAttributes()
        setupLayout()
        setupCompositionalLayout()
    }
    
}

// MARK: - Setup Functions

private extension TimelineVC {
    func setupAttributes() {
        view.backgroundColor = TLColor.black
    }
    
    func setupLayout() {
        view.addSubviews(timelineCollectionView)
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            timelineCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            timelineCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timelineCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timelineCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupCompositionalLayout() {
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            switch section {
            case 0:
                self?.makeTravelInfoSection()
            default:
                self?.makeTravelInfoSection()
            }
        }
        
        timelineCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func makeTravelInfoSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(Metric.travelInfoEstimatedHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: size)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: size,
            repeatingSubitem: item,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
}

// MARK: - UICollectionView Delegate

extension TimelineVC: UICollectionViewDelegate {
    
}

extension TimelineVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeue(cell: TravelInfoCVC.self, for: indexPath)
            cell.setData(from: TimelineSample.makeTravelInfo())
            cell.delegate = self
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - TravelInfo Delegate

extension TimelineVC: TravelInfoDelegate {
    func likeChanged(to isLiked: Bool) {
        // TODO: - 좋아요 변경 처리
        print("Like Changed")
    }
}

@available(iOS 17, *)
#Preview {
    UINavigationController(rootViewController: TimelineVC())
}
