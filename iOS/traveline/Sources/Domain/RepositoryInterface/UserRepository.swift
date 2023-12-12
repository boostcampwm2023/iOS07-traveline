//
//  UserRepository.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/04.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

protocol UserRepository {
    func fetchUserInfo() async throws -> Profile
    func updateUserInfo(name: String, imageData: Data?) async throws -> Profile
    func checkDuplication(name: String) async throws -> Bool
}
