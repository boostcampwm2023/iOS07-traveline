//
//  VCFactory.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

import Data
import Domain
import Feature

public final class VCFactory: FactoryInterface {
    
    public let network: NetworkType = NetworkManager(urlSession: URLSession.shared)
    
    public func makeAutoLoginVC() -> AutoLoginVC {
        let repository = AuthRepositoryImpl(network: network)
        let useCase = AutoLoginUseCaseImpl(repository: repository)
        let viewModel = AutoLoginViewModel(useCase: useCase)
        let vc = AutoLoginVC(viewModel: viewModel, factory: self)
        return vc
    }
    
    public func makeLoginVC() -> LoginVC {
        let repository = AuthRepositoryImpl(network: network)
        let useCase = LoginUseCaseImpl(repository: repository)
        let viewModel = LoginViewModel(useCase: useCase)
        return LoginVC(viewModel: viewModel, factory: self)
    }
    
    public func makeRootContainerVC() -> RootContainerVC {
        return RootContainerVC(factory: self)
    }
    
    public func makeTimelineVC(id: TravelID) -> TimelineVC {
        let postingRepository = PostingRepositoryImpl(network: network)
        let timelineRepository = TimelineRepositoryImpl(network: network)
        let useCase = TimelineUseCaseImpl(
            postingRepository: postingRepository,
            timelineRepository: timelineRepository
        )
        let viewModel = TimelineViewModel(
            id: id,
            fetchTravelInfoUseCase: useCase
        )
        return TimelineVC(viewModel: viewModel, factory: self)
    }
    
    public func makeHomeVC() -> HomeVC {
        let repository = PostingRepositoryImpl(network: network)
        let useCase = HomeUseCaseImpl(repository: repository)
        let viewModel = HomeViewModel(homeUseCase: useCase)
        return HomeVC(viewModel: viewModel, factory: self)
    }
    
    public func makeTimelineDetailVC(with id: String) -> TimelineDetailVC {
        let repository = TimelineDetailRepositoryImpl(network: network)
        let useCase = TimelineDetailUseCaseImpl(repository: repository)
        let viewModel = TimelineDetailViewModel(
            timelineDetailUseCase: useCase,
            timelineId: id
        )
        return TimelineDetailVC(viewModel: viewModel, factory: self)
    }
    
    public func makeMyPostListVC() -> MyPostListVC {
        let repository = PostingRepositoryImpl(network: network)
        let useCase = MyPostListUseCaseImpl(repository: repository)
        let viewModel = MyPostListViewModel(myPostListUseCase: useCase)
        return MyPostListVC(viewModel: viewModel, factory: self)
    }
    
    public func makeTravelVC(
        id: TravelID? = nil,
        travelInfo: TimelineTravelInfo? = nil
    ) -> TravelVC {
        let repository = PostingRepositoryImpl(network: network)
        let useCase = TravelUseCaseImpl(repository: repository)
        let viewModel = TravelViewModel(
            id: id,
            travelInfo: travelInfo,
            travelUseCase: useCase
        )
        return TravelVC(viewModel: viewModel, factory: self)
    }
    
    public func makeTimelineWritingVC(
        id: TravelID,
        date: String,
        day: Int,
        timelineDetailInfo: TimelineDetailInfo? = nil
    ) -> TimelineWritingVC {
        let repository = TimelineDetailRepositoryImpl(network: network)
        let useCase = TimelineWritingUseCaseImpl(repository: repository)
        let viewModel = TimelineWritingViewModel(
            useCase: useCase,
            id: id,
            date: date,
            day: day,
            timelineDetailInfo: timelineDetailInfo
        )
        return TimelineWritingVC(viewModel: viewModel)
    }
    
    public func makeSideMenuVC() -> SideMenuVC {
        let repository = UserRepositoryImpl(network: network)
        let useCase = SideMenuUseCaseImpl(repository: repository)
        let viewModel = SideMenuViewModel(useCase: useCase)
        return SideMenuVC(viewModel: viewModel)
    }
    
    public func makeSettingVC() -> SettingVC {
        let repository = AuthRepositoryImpl(network: network)
        let useCase = SettingUseCaseImpl(repository: repository)
        let viewModel = SettingViewModel(useCase: useCase)
        return SettingVC(viewModel: viewModel)
    }
    
    public func makeProfileEditingVC() -> ProfileEditingVC {
        let repository = UserRepositoryImpl(network: network)
        let useCase = ProfileEditingUseCaseImpl(repository: repository)
        let viewModel = ProfileEditingViewModel(useCase: useCase)
        return ProfileEditingVC(viewModel: viewModel)
    }
    
}
