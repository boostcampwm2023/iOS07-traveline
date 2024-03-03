//
//  UICollectionView+.swift
//  traveline
//
//  Created by 김태현 on 11/22/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

extension UICollectionView {
    /// UICollectionViewCell 등록
    public func register<T: UICollectionViewCell>(cell: T.Type) {
        let identifier = String(describing: cell)
        register(cell, forCellWithReuseIdentifier: identifier)
    }
    
    /// UICollectionView Header 등록
    public func registerHeader<T: UICollectionReusableView>(view: T.Type) {
        let identifier = String(describing: view)
        register(
            view,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: identifier
        )
    }
    
    /// 재사용 Cell dequeue
    public func dequeue<T: UICollectionViewCell>(cell: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: cell)
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: identifier,
            for: indexPath
        ) as? T else {
            fatalError("등록되지 않은 \(cell)입니다.")
        }
        return cell
    }
    
    /// 재사용 Header View dequeue
    public func dequeHeader<T: UICollectionReusableView>(view: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: view)
        guard let view = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: identifier,
            for: indexPath
        ) as? T else {
            fatalError("등록되지 않은 \(view)입니다.")
        }
        return view
    }
}
