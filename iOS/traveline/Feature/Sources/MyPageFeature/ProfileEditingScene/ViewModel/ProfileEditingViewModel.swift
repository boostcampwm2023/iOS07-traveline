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

import Core
import DesignSystem
import Domain

public enum ProfileEditingAction: BaseAction {
    case viewDidLoad
    case imageDidChange(Bool)
    case nicknameDidChange(String)
    case tapCompleteButton(Data?)
}

public enum ProfileEditingSideEffect: BaseSideEffect {
    case fetchProfile(Profile)
    case error(String)
    case updateImageState(Bool)
    case validateNickname(CaptionOptions)
    case updateProfile
}

public struct ProfileEditingState: BaseState {
    var isCompletable: Bool = false
    var profile: Profile = .empty
    var caption: CaptionOptions = .init(validateType: .unchanged)
    var isSuccessEditProfile: Bool = false
    
    public init() { }
}

public struct CaptionOptions {
    var validateType: NicknameValidationState
    
    var text: String {
        switch self.validateType {
        case .unchanged: return " "
        case .tooShort: return "닉네임은 2자 이상만 가능합니다."
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

public final class ProfileEditingViewModel: BaseViewModel<ProfileEditingAction, ProfileEditingSideEffect, ProfileEditingState> {
    
    private var isChangedImage: Bool = false
    private var changedNickname: String = ""
    private let useCase: ProfileEditingUseCase
    
    public init(useCase: ProfileEditingUseCase) {
        self.useCase = useCase
        super.init()
    }
    
    public override func transform(action: Action) -> SideEffectPublisher {
        switch action {
        case .viewDidLoad:
            return fetchProfile()
        case let .nicknameDidChange(nickname):
            changedNickname = nickname
            return validate(changedNickname)
            
        case let .imageDidChange(state):
            return .just(ProfileEditingSideEffect.updateImageState(state))
            
        case .tapCompleteButton(let imageData):
            return updateProfile(with: imageData)
        }
    }
    
    public override func reduceState(state: State, effect: SideEffect) -> State {
        var newState = state
        
        switch effect {
        case let .fetchProfile(profile):
            changedNickname = profile.name
            newState.profile = profile
            
        case .error:
            newState.isSuccessEditProfile = false
            
        case let .validateNickname(caption):
            newState.caption = caption
            newState.isCompletable = completeButtonState(isChangedImage: isChangedImage, nicknameState: newState.caption.validateType)
            
        case .updateProfile:
            newState.isSuccessEditProfile = true

        case let .updateImageState(isChangedImage):
            self.isChangedImage = isChangedImage
            newState.isCompletable = completeButtonState(isChangedImage: isChangedImage, nicknameState: newState.caption.validateType)
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
    
    private func completeButtonState(isChangedImage: Bool, nicknameState: NicknameValidationState) -> Bool {
        switch (isChangedImage, nicknameState) {
        case (_, .available): return true
        case (true, .unchanged): return true
        default: return false
        }
    }
    
    private func validate(_ nickname: String) -> SideEffectPublisher {
        return useCase.validate(nickname: nickname)
            .map { validationState in
                let caption = CaptionOptions(validateType: validationState)
                return .validateNickname(caption)
            }
            .catch { _ in
                return Just(.error("validate request error"))
            }
            .eraseToAnyPublisher()
    }
    
    private func updateProfile(with imageData: Data?) -> SideEffectPublisher {
        return useCase.update(name: changedNickname, imageData: imageData)
            .map { _ in
                return .updateProfile
            }
            .catch { _ in
                return Just(.error("profile update error"))
            }
            .eraseToAnyPublisher()
    }
}
