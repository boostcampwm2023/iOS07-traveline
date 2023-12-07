//
//  NetworkManager.swift
//  traveline
//
//  Created by 김영인 on 2023/11/14.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation
import OSLog

protocol NetworkType {
    func request<T: Decodable>(endPoint: EndPoint, type: T.Type) async throws -> T
    func requestWithNoResult(endPoint: EndPoint) async throws -> Bool
}

final class NetworkManager: NetworkType {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func request<T: Decodable>(endPoint: EndPoint, type: T.Type) async throws -> T {
        os_log("networking start")
        
        let urlRequest = try makeURLRequest(endPoint: endPoint)
        let (data, response) = try await urlSession.data(for: urlRequest)
        
        os_log("data: \(data)\nresponse: \(response)")
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.httpResponseError
        }
        
        try validateStatusCode(httpResponse.statusCode)
        
        os_log("statusCode: \(httpResponse.statusCode)")
        
        do {
            let decodedData: T = try decodeData(data: data)
            return decodedData
        } catch {
            guard let error = error as? DecodingError else {
                os_log("otherError: \(error.localizedDescription)")
                throw NetworkError.serverError
            }
            os_log("decodingError: \(error)")
            throw NetworkError.decodeError
        }
    }
    
    func requestWithNoResult(endPoint: EndPoint) async throws -> Bool {
        let urlRequest = try makeURLRequest(endPoint: endPoint)
        let (_, response) = try await urlSession.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.httpResponseError
        }
        
        do {
            try validateStatusCode(httpResponse.statusCode)
        } catch {
            return false
        }
        
        return true
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
    
    func validateStatusCode(_ statusCode: Int) throws {
        guard 200..<300 ~= statusCode else {
            switch statusCode {
            case 300..<400:
                throw NetworkError.redirectionError
            case 400..<500:
                throw NetworkError.clientError
            default:
                throw NetworkError.serverError
            }
        }
    }
    
    func makeURLRequest(endPoint: EndPoint) throws -> URLRequest {
        os_log("url: \(endPoint.baseURL ?? "empty")\(endPoint.path ?? "empty")")
        
        guard let baseURL = endPoint.baseURL,
              let path = endPoint.path,
              let url = URL(string: baseURL + path) else {
            os_log("urlError")
            throw NetworkError.urlError
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.httpMethod.rawValue
        
        if let httpBody = endPoint.body {
            do {
                urlRequest.httpBody = try JSONEncoder().encode(httpBody)
                
                if let jsonString = String(data: urlRequest.httpBody ?? Data(), encoding: .utf8) {
                    os_log("httpBody: \(jsonString)")
                }
            } catch {
                os_log("encodeError")
                throw NetworkError.encodeError
            }
        }
        
        if let multipartData = endPoint.multipartData {
            urlRequest.httpBody = makeBody(multipartData: multipartData)
            
            if let jsonString = String(data: urlRequest.httpBody ?? Data(), encoding: .utf8) {
                os_log("multipart-httpBody: \(jsonString)")
            }
        }
        
        urlRequest.allHTTPHeaderFields = endPoint.header.value
        os_log("header: \(urlRequest.allHTTPHeaderFields ?? [:])")
        
        return urlRequest
    }
    
    func makeBody(multipartData: MultipartData) -> Data {
        var body = Data()
        let imageLabel = "image"
        let boundaryPrefix = "--\(Literal.boundary)\r\n"
        let boundaryPostfix = "--\(Literal.boundary)--"
        
        Mirror(reflecting: multipartData).children
            .filter {
                if case Optional<Any>.some = $0.value { return true }
                return false
            }
            .forEach { child in
                guard let label = child.label else { return }
                let value = child.value
                
                if label == imageLabel {
                    guard let imageData = value as? Data else { return }
                    os_log("imageData: \(imageData.megabytes())")
                    body.append(boundaryPrefix.toUTF8())
                    body.append("Content-Disposition: form-data; name=\"\(label)\"; filename=\"\(label).jpg\"\r\n".toUTF8())
                    body.append("Content-Type: image/jpeg\r\n\r\n".toUTF8())
                    body.append(imageData)
                    body.append("\r\n".toUTF8())
                } else {
                    body.append(boundaryPrefix.toUTF8())
                    body.append("Content-Disposition: form-data; name=\"\(label)\"\r\n\r\n".toUTF8())
                    body.append("\(value)\r\n".toUTF8())
                }
            }
        
        body.append(boundaryPostfix.toUTF8())
        return body
    }
}
