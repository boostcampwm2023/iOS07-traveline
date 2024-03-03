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
    /// imagePath를 Key로 사용합니다.
    /// 캐시에 존재한다면 캐시에서 가져오고, 없으면 다운로드합니다.
    /// - Parameters:
    ///   - urlString: 이미지 URL 문자열
    ///   - imagePath: 이미지 캐싱 키, nil 시에는 다운로드만 진행
    func setImage(from urlString: String?, imagePath: String?) {
        guard let urlString else { return }
        
        if let imagePath,
           let cachedImageData = TLImageCache.shared.fetch(imagePath) {
            image = UIImage(data: cachedImageData)
            return
        }
        
        Task {
            guard let downloadImageData = await TLImageDownloader.shared.download(key: self, urlString: urlString) else { return }
            image = UIImage(data: downloadImageData)
            
            if let imagePath {
                TLImageCache.shared.store(downloadImageData, imagePath: imagePath)
            }
        }
    }
    
    /// 재사용 시 기존 UIImageView의 Download Task를 취소합니다.
    func cancel() {
        TLImageDownloader.shared.cancelDownload(key: self)
    }
    
}

extension UIImage {
    
    /// 이미지 다운샘플링을 수행합니다.
    /// - Parameters:
    ///    - scale: 이미지 크기를 조절하는 비율. 기본값은 0.2로, 결과 이미지는 원본의 2/10 크기가 됩니다.
    /// - Returns: 작업이 성공하면 다운샘플링된 UIImage를 반환하고, 그렇지 않으면 nil을 반환합니다.
    func downSampling(scale: CGFloat = 0.2) -> UIImage? {
        let imageSourceOption = [kCGImageSourceShouldCache: false] as CFDictionary
        
        guard let imageData = self.jpegData(compressionQuality: 1),
              let data = imageData as CFData?,
              let imageSource = CGImageSourceCreateWithData(data, imageSourceOption) else {
            return nil
        }
        
        let maxPixel = max(self.size.width, self.size.height) * scale
        let downSampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixel
        ] as CFDictionary
        
        guard let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions) else {
            return nil
        }
        
        return UIImage(cgImage: downSampledImage)
    }
}
