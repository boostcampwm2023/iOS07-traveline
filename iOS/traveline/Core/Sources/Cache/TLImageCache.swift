//
//  TLImageCache.swift
//  traveline
//
//  Created by 김태현 on 11/26/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

public final class TLImageCache {
    
    public static let shared = TLImageCache()
    
    private let imageCacheRepository: ImageCacheRepository = ImageCacheRepositoryImpl(fileManager: FileManager.default)
    
    private init() {}
    
    // MARK: - Functions
    
    public func fetch(_ urlString: String) -> Data? {
        imageCacheRepository.fetch(urlString)
    }
    
    public func store(_ data: Data, imagePath: String) {
        imageCacheRepository.store(data, cacheKey: imagePath)
    }
    
}
