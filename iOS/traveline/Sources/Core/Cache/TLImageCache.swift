//
//  TLImageCache.swift
//  traveline
//
//  Created by 김태현 on 11/26/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

final class TLImageCache {
    
    static let shared = TLImageCache()
    
    private let imageCacheRepository: ImageCacheRepository = ImageCacheRepositoryImpl(fileManager: FileManager.default)
    
    private init() {}
    
    // MARK: - Functions
    
    func fetch(_ urlString: String) -> Data? {
        imageCacheRepository.fetch(urlString)
    }
    
    func store(_ data: Data, urlString: String) {
        imageCacheRepository.store(data, cacheKey: urlString)
    }
    
}
