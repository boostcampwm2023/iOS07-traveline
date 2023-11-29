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
    case nickNameDidChange(String)
    case tapCompleteButton
}

enum ProfileEditingSideEffect: BaseSideEffect {
    case updateImageState(ProfileEditingViewModel.ImageState)
    case validateNickName(String)
    case updateProfile
}

struct ProfileEditingState: BaseState {
    
    var isCompletable: Bool = false
    var nickNameState: ProfileEditingViewModel.NickNameState = .unchanged
}

final class ProfileEditingViewModel: BaseViewModel<ProfileEditingAction, ProfileEditingSideEffect, ProfileEditingState> {
    
    enum NickNameState {
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
    
    private let profile: Profile
    private var imageState: ImageState = .none
    var currentNickName: String
    
    init(profile: Profile) {
        self.profile = profile
        self.currentNickName = profile.name
        super.init()
    }
    
    override func transform(action: Action) -> SideEffectPublisher {
        switch action {
        case let .nickNameDidChange(text):
                .just(ProfileEditingSideEffect.validateNickName(text))
            
        case let .imageDidChange(state):
                .just(ProfileEditingSideEffect.updateImageState(state))
            
        case .tapCompleteButton:
                .just(ProfileEditingSideEffect.updateProfile)
        }
    }
    
    override func reduceState(state: State, effect: SideEffect) -> State {
        var newState = state
        
        switch effect {
        case let .validateNickName(text):
            newState.nickNameState = updateNickNameState(text)
            newState.isCompletable = completeButtonState(imageState: imageState, nickNameState: newState.nickNameState)
            
        case .updateProfile:
            updateProfile()
            
        case let .updateImageState(imageState):
            self.imageState = imageState
            newState.isCompletable = completeButtonState(imageState: imageState, nickNameState: newState.nickNameState)
        }
        
        return newState
    }
}

// MARK: - Functions

extension ProfileEditingViewModel {
    
    private func completeButtonState(imageState: ImageState, nickNameState: NickNameState) -> Bool {
        switch (imageState, nickNameState) {
        case (_, .available): return true
        case (.album, .unchanged): return true
        case (.basic, .unchanged): return true
        default: return false
        }
    }
    private func updateNickNameState(_ nickName: String) -> NickNameState {
        guard isValidStringLength(nickName: nickName) else {
            return .exceededStringLength
        }
        guard isAvailable(nickName: nickName) else {
            return .duplicated
        }
        guard isNewNickName(nickName) else {
            return .unchanged
        }
        return .available
    }
    
    private func isNewNickName(_ nickName: String) -> Bool {
        return profile.name != nickName
    }
    
    private func isValidStringLength(nickName: String) -> Bool {
        return nickName.count < 11
    }
    
    private func isAvailable(nickName: String) -> Bool {
        // TODO: 중복검사 요청 구현
        return true
    }
    
    private func updateProfile() {
        // TODO: 프로필 업데이트 구현
    }
}
