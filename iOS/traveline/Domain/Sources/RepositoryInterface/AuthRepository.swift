//
//  AuthRepository.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/05.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Core

protocol AuthRepository {
    func refresh() async throws -> String
    func appleLogin(with info: AppleLoginRequest) async throws -> TLToken
    func withdrawal(_ request: WithdrawRequest) async throws -> Bool
    func requestAppleId() -> AppleIDRequest
    func logout()
}
