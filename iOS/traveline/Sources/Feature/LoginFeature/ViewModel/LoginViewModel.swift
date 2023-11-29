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
            requestAppleLogin()
        case let .successAppleLogin(auth):
            handleAppleAuth(auth)
        case .failAppleLogin:
                .just(LoginSideEffect.completeAppleLogin(false))
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
        
        return .just(LoginSideEffect.requestAppleLogin(request))
    }
    
    func handleAppleAuth(_ auth: Auth) -> SideEffectPublisher {
        guard let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential else {
            return .just(LoginSideEffect.completeAppleLogin(false))
        }
        
        let userIdentifier = appleIDCredential.user
        if let identityToken = appleIDCredential.identityToken,
           let identityTokenString = String(data: identityToken, encoding: .utf8) {
            // TODO: 로그인 API에 identityTokenString 담아서 로그인하기
        }
        
        return .just(LoginSideEffect.completeAppleLogin(true))
    }
}
