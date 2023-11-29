//
//  ProfileEditingViewModel.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/28.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation
import Combine

enum ProfileEditingAction: BaseAction {
    case imageDidChange(ProfileEditingViewModel.ImageState)
    case nicknameDidChange(String)
    case tapCompleteButton
}

enum ProfileEditingSideEffect: BaseSideEffect {
    case updateImageState(ProfileEditingViewModel.ImageState)
    case validateNickname(String)
    case updateProfile
}

struct ProfileEditingState: BaseState {
    
    var isCompletable: Bool = false
    var nicknameState: ProfileEditingViewModel.NicknameState = .unchanged
}

final class ProfileEditingViewModel: BaseViewModel<ProfileEditingAction, ProfileEditingSideEffect, ProfileEditingState> {
    
    enum NicknameState {
        case unchanged
        case available
        case duplicated
        case exceededStringLength
        
        var text: String {
            switch self {
            case .unchanged: return " "
            case .available: return "사용가능한 닉네임입니다."
            case .duplicated: return "이미 사용중인 닉네임입니다."
            case .exceededStringLength: return "닉네임은 10자 이내만 가능합니다."
            }
        }
    }
    
    enum ImageState {
        case none
        case basic
        case album
    }
    
    let profile: Profile
    private var imageState: ImageState = .none
    
    init(profile: Profile) {
        self.profile = profile
        super.init()
    }
    
    override func transform(action: Action) -> SideEffectPublisher {
        switch action {
        case let .nicknameDidChange(text):
            return .just(ProfileEditingSideEffect.validateNickname(text))
            
        case let .imageDidChange(state):
            return .just(ProfileEditingSideEffect.updateImageState(state))
            
        case .tapCompleteButton:
            return .just(ProfileEditingSideEffect.updateProfile)
        }
    }
    
    override func reduceState(state: State, effect: SideEffect) -> State {
        var newState = state
        
        switch effect {
        case let .validateNickname(text):
            newState.nicknameState = updateNicknameState(text)
            newState.isCompletable = completeButtonState(imageState: imageState, nicknameState: newState.nicknameState)
            
        case .updateProfile:
            updateProfile()
            
        case let .updateImageState(imageState):
            self.imageState = imageState
            newState.isCompletable = completeButtonState(imageState: imageState, nicknameState: newState.nicknameState)
        }
        
        return newState
    }
}

// MARK: - Functions

extension ProfileEditingViewModel {
    
    private func completeButtonState(imageState: ImageState, nicknameState: NicknameState) -> Bool {
        switch (imageState, nicknameState) {
        case (_, .available): return true
        case (.album, .unchanged): return true
        case (.basic, .unchanged): return true
        default: return false
        }
    }
    
    private func updateNicknameState(_ nickname: String) -> NicknameState {
        guard isValidStringLength(nickname: nickname) else {
            return .exceededStringLength
        }
        guard isAvailable(nickname: nickname) else {
            return .duplicated
        }
        guard isNewNickname(nickname) else {
            return .unchanged
        }
        return .available
    }
    
    private func isNewNickname(_ nickname: String) -> Bool {
        return profile.name != nickname
    }
    
    private func isValidStringLength(nickname: String) -> Bool {
        return nickname.count < 11
    }
    
    private func isAvailable(nickname: String) -> Bool {
        // TODO: 중복검사 요청 구현
        return true
    }
    
    private func updateProfile() {
        // TODO: 프로필 업데이트 구현
    }
}
