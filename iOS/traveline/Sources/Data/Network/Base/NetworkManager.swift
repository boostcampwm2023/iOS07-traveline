//
//  NetworkManager.swift
//  traveline
//
//  Created by 김영인 on 2023/11/14.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

protocol NetworkType {
    func request<T: Decodable>(endPoint: EndPoint, type: T.Type) async throws -> T
}

final class NetworkManager: NetworkType {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func request<T: Decodable>(endPoint: EndPoint, type: T.Type) async throws -> T {
        let urlRequest = try makeURLRequest(endPoint: endPoint)
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.httpResponseError
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            switch httpResponse.statusCode {
            case 300..<400:
                throw NetworkError.redirectionError
            case 400..<500:
                throw NetworkError.clientError
            default:
                throw NetworkError.serverError
            }
        }
        
        do {
            let decodedData: T = try decodeData(data: data)
            return decodedData
        } catch {
            throw NetworkError.decodeError
        }
    }
    
}

private extension NetworkManager {
    
    func decodeData<T: Decodable>(data: Data) throws -> T {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            throw NetworkError.decodeError
        }
    }
    
    func makeURLRequest(endPoint: EndPoint) throws -> URLRequest {
        guard let url = URL(string: endPoint.baseURL + endPoint.path) else {
            throw NetworkError.urlError
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.httpMethod.rawValue
        
        if let httpBody = endPoint.body {
            do {
                urlRequest.httpBody = try JSONEncoder().encode(httpBody)
            } catch {
                throw NetworkError.encodeError
            }
        }
        
        urlRequest.allHTTPHeaderFields = endPoint.header
        
        return urlRequest
    }
    
}
