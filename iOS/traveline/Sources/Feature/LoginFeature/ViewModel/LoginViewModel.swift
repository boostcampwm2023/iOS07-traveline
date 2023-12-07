//
//  LoginViewModel.swift
//  traveline
//
//  Created by 김영인 on 2023/11/29.
//  Copyright © 2023 traveline. All rights reserved.
//

import AuthenticationServices
import Foundation

typealias AppleIDRequest = ASAuthorizationAppleIDRequest
typealias Auth = ASAuthorization

enum LoginAction: BaseAction {
    case startAppleLogin
    case successAppleLogin(Auth)
    case failAppleLogin
}

enum LoginSideEffect: BaseSideEffect {
    case requestAppleLogin(AppleIDRequest)
    case completeAppleLogin(Bool)
}

struct LoginState: BaseState {
    var appleIDRequests: [AppleIDRequest]?
    var isSuccessLogin: Bool = false
}

final class LoginViewModel: BaseViewModel<LoginAction, LoginSideEffect, LoginState> {
    
    override func transform(action: LoginAction) -> SideEffectPublisher {
        switch action {
        case .startAppleLogin:
            return requestAppleLogin()
            
        case let .successAppleLogin(auth):
            return handleAppleAuth(auth)
            
        case .failAppleLogin:
            return .just(LoginSideEffect.completeAppleLogin(false))
        }
    }
    
    override func reduceState(state: LoginState, effect: LoginSideEffect) -> LoginState {
        var newState = state
        
        switch effect {
        case let .requestAppleLogin(request):
            newState.appleIDRequests = [request]
            
        case let .completeAppleLogin(isSuccess):
            newState.isSuccessLogin = isSuccess
        }
        
        return newState
    }
}

private extension LoginViewModel {
    func requestAppleLogin() -> SideEffectPublisher {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]
        
        return .just(LoginSideEffect.requestAppleLogin(request))
    }
    
    func handleAppleAuth(_ auth: Auth) -> SideEffectPublisher {
        guard let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential else {
            return .just(LoginSideEffect.completeAppleLogin(false))
        }
        
        if let identityToken = appleIDCredential.identityToken,
           let authorizationCode = appleIDCredential.authorizationCode,
           let identityTokenString = String(data: identityToken, encoding: .utf8),
           let authorizationCodeString = String(data: authorizationCode, encoding: .utf8) {
            
            let network = NetworkManager(urlSession: URLSession.shared)
            let loginRequestDTO: LoginRequestDTO = .init(idToken: identityTokenString, email: appleIDCredential.email)
            
            Task {
                let loginResponseDTO = try await network.request(endPoint: AuthEndPoint.login(loginRequestDTO), type: LoginResponseDTO.self)
                KeychainList.accessToken = loginResponseDTO.accessToken
                KeychainList.refreshToken = loginResponseDTO.refreshToken
            }
            KeychainList.identityToken = identityTokenString
            KeychainList.authorizationCode = authorizationCodeString
        }
        
        return .just(LoginSideEffect.completeAppleLogin(true))
    }
}
