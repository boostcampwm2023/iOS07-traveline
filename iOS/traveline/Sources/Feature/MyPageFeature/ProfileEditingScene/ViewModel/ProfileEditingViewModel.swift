//
//  ProfileEditingViewModel.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/28.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation
import OSLog

enum ProfileEditingAction: BaseAction {
    case viewDidLoad
    case imageDidChange(ProfileEditingViewModel.ImageState)
    case nicknameDidChange(String)
    case tapCompleteButton(Profile)
}

enum ProfileEditingSideEffect: BaseSideEffect {
    case fetchProfile(Profile)
    case error(String)
    case updateImageState(ProfileEditingViewModel.ImageState)
    case validateNickname(CaptionOptions)
    case updateProfile
}

struct ProfileEditingState: BaseState {
    
    var isCompletable: Bool = false
    var profile: Profile = .empty
    var caption: CaptionOptions = .init(validateType: .unchanged)
}

struct CaptionOptions {
    var validateType: NicknameValidationState
    
    var text: String {
        switch self.validateType {
        case .unchanged: return " "
        case .available: return "사용가능한 닉네임입니다."
        case .duplicated: return "이미 사용중인 닉네임입니다."
        case .exceededStringLength: return "닉네임은 10자 이내만 가능합니다."
        }
    }
    
    var isError: Bool {
        switch self.validateType {
        case .unchanged, .available: return false
        default: return true
        }
    }
}

final class ProfileEditingViewModel: BaseViewModel<ProfileEditingAction, ProfileEditingSideEffect, ProfileEditingState> {
    
    enum ImageState {
        case none
        case basic
        case album
    }
    
    private var imageState: ImageState = .none
    private var changedNickname: String = ""
    private let useCase: ProfileEditingUseCase
    
    init(useCase: ProfileEditingUseCase) {
        self.useCase = useCase
        super.init()
    }
    
    override func transform(action: Action) -> SideEffectPublisher {
        switch action {
        case .viewDidLoad:
            return fetchProfile()
        case let .nicknameDidChange(nickname):
            changedNickname = nickname
            return validate(changedNickname)
            
        case let .imageDidChange(state):
            return .just(ProfileEditingSideEffect.updateImageState(state))
            
        case .tapCompleteButton(let profile):
            return updateProfile(profile: profile)
        }
    }
    
    override func reduceState(state: State, effect: SideEffect) -> State {
        var newState = state
        
        switch effect {
        case let .fetchProfile(profile):
            newState.profile = profile
            
        case .error:
            break
            
        case let .validateNickname(caption):
            newState.caption = caption
            newState.isCompletable = completeButtonState(imageState: imageState, nicknameState: newState.caption.validateType)
            
        case .updateProfile:
            os_log("update profile")
            
        case let .updateImageState(imageState):
            self.imageState = imageState
            newState.isCompletable = completeButtonState(imageState: imageState, nicknameState: newState.caption.validateType)
        }
        
        return newState
    }
}

// MARK: - Functions

extension ProfileEditingViewModel {
    
    private func fetchProfile() -> SideEffectPublisher {
        return useCase.fetchProfile()
            .map { profile in
                return .fetchProfile(profile)
            }
            .catch { _ in
                return Just(.error("profile fetch error"))
            }
            .eraseToAnyPublisher()
    }
    
    private func completeButtonState(imageState: ImageState, nicknameState: NicknameValidationState) -> Bool {
        switch (imageState, nicknameState) {
        case (_, .available): return true
        case (.album, .unchanged): return true
        case (.basic, .unchanged): return true
        default: return false
        }
    }
    
    private func validate(_ nickname: String) -> SideEffectPublisher {
        return useCase.validate(nickname: nickname)
            .map { validationState in
                let caption = CaptionOptions(validateType: validationState)
                return .validateNickname(caption)
            }
            .eraseToAnyPublisher()
    }
    
    private func updateProfile(profile: Profile) -> SideEffectPublisher {
        return useCase.fetchProfile()
            .map { profile in
                return .updateProfile
            }
            .catch { _ in
                return Just(.error("profile update error"))
            }
            .eraseToAnyPublisher()
    }
}
