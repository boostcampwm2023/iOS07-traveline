//
//  UIImageView+.swift
//  traveline
//
//  Created by 김태현 on 11/26/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import UIKit

extension UIImageView {
    
    /// urlString으로부터 이미지를 Load 합니다.
    /// 캐시에 존재한다면 캐시에서 가져오고, 없으면 다운로드합니다.
    /// - Parameter urlString: 이미지 URL 문자열
    func setImage(from urlString: String?) {
        guard let urlString else { return }
        
        if let cachedImageData = TLImageCache.shared.fetch(urlString) {
            image = UIImage(data: cachedImageData)
            return
        }
        
        Task {
            guard let downloadImageData = await TLImageDownloader.shared.download(key: self, urlString: urlString) else { return }
            TLImageCache.shared.store(downloadImageData, urlString: urlString)
            image = UIImage(data: downloadImageData) 
        }
    }
    
    /// 재사용 시 기존 UIImageView의 Download Task를 취소합니다.
    func cancel() {
        TLImageDownloader.shared.cancelDownload(key: self)
    }
    
}
