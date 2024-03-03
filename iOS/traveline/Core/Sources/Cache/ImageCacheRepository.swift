//
//  ImageCacheRepository.swift
//  traveline
//
//  Created by 김태현 on 11/26/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

protocol ImageCacheRepository {
    func fetch(_ cacheKey: String) -> Data?
    func store(_ data: Data, cacheKey: String)
}

final class ImageCacheRepositoryImpl: ImageCacheRepository {
    
    private enum Constants {
        static let cacheDataName: String = "cacheImageData"
    }
    
    private let memoryCache: NSCache<NSString, NSData> = .init()
    private let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    // MARK: - Functions
    
    func fetch(_ cacheKey: String) -> Data? {
        if let memoryCachedData = fetchFromMemoryData(cacheKey) {
            return memoryCachedData
        }
        
        if let diskCachedData = fetchFromDiskData(cacheKey) {
            storeToMemoryCache(diskCachedData, cacheKey: cacheKey)
            return diskCachedData
        }
        return nil
    }
    
    func store(_ data: Data, cacheKey: String) {
        storeToMemoryCache(data, cacheKey: cacheKey)
        storeToDiskCache(data, cacheKey: cacheKey)
    }
    
    // MARK: - Memory
    
    private func fetchFromMemoryData(_ cacheKey: String) -> Data? {
        return memoryCache.object(forKey: cacheKey as NSString) as? Data
    }
    
    private func storeToMemoryCache(_ data: Data, cacheKey: String) {
        return memoryCache.setObject(data as NSData, forKey: cacheKey as NSString)
    }
    
    // MARK: - Disk
    
    private func fetchFromDiskData(_ cacheKey: String) -> Data? {
        guard let cacheDirectoryURL = makeCacheDirectoryURL(cacheKey: cacheKey) else { return nil }
        let cacheDataURL = cacheDirectoryURL.appending(path: Constants.cacheDataName)
        return try? Data(contentsOf: cacheDataURL)
    }
    
    private func storeToDiskCache(_ data: Data, cacheKey: String) {
        guard let cacheDirectoryURL = makeCacheDirectoryURL(cacheKey: cacheKey) else { return }
        let cacheDataURL = cacheDirectoryURL.appending(path: Constants.cacheDataName)
        try? fileManager.createDirectory(atPath: cacheDirectoryURL.path(), withIntermediateDirectories: true)
        fileManager.createFile(atPath: cacheDataURL.path(), contents: data)
    }
    
    // MARK: - File URL
    
    private func makeCacheDirectoryURL(cacheKey: String) -> URL? {
        return fileManager
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appending(path: cacheKey)
    }
    
}
