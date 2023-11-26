//
//  TLImageDownloader.swift
//  traveline
//
//  Created by 김태현 on 11/26/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

final class TLImageDownloader {
    
    static let shared = TLImageDownloader()
    
    private let downloadTaskQueue = DispatchQueue(label: "TLImageDownloader")
    private var downloadTasks: [AnyHashable: Task<Data, Error>] = .init()
    
    private init() {}
    
    // MARK: - Functions
    
    /// 기존의 Download Task를 취소합니다.
    /// - Parameter key: 취소할 UIImageView
    func cancelDownload(key: AnyHashable) {
        downloadTaskQueue.async { [weak self] in
            self?.downloadTasks[key]?.cancel()
            self?.downloadTasks[key] = nil
        }
    }
    
    /// URL에서 이미지를 다운로드합니다.
    /// - Parameters:
    ///   - key: 다운로드할 UIImageView
    ///   - urlString: 다운로드할 URL 문자열
    /// - Returns: 다운로드 받은 이미지 데이터
    func download(key: AnyHashable, urlString: String) async -> Data? {
        guard let url = URL(string: urlString) else { return nil }
        let downloadTask = Task {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        }
        
        downloadTaskQueue.async { [weak self] in
            self?.downloadTasks[key] = downloadTask
        }
        
        return try? await downloadTask.value
    }
    
}
