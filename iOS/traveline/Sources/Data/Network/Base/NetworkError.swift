//
//  NetworkError.swift
//  traveline
//
//  Created by 김영인 on 2023/11/14.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError {
    case urlError
    case encodeError
    case decodeError
    case httpResponseError
    case redirectionError
    case clientError
    case serverError
    
    var errorDescription: String? {
        switch self {
        case .urlError:
            "유효하지 않은 url입니다."
        case .encodeError:
            "인코딩에 실패했습니다."
        case .decodeError:
            "디코딩에 실패했습니다."
        case .httpResponseError:
            "잘못된 http 응답입니다."
        case .redirectionError:
            "리다이레션 에러입니다."
        case .clientError:
            "잘못된 요청입니다."
        case .serverError:
            "알 수 없는 오류입니다."
        }
    }
}
