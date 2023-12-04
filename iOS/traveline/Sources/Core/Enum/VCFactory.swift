//
//  VCFactory.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum VCFactory {
    
    static let network: NetworkType = NetworkManager(urlSession: URLSession.shared)
    
    static func makeTimelineVC() -> TimelineVC {
        let repository = TimelineRepositoryMock()
//        let repository = TimelineRepositoryImpl(network: network)
        let useCase = FetchTravelInfoUseCaseImpl(repository: repository)
        let viewModel = TimelineViewModel(fetchTravelInfoUseCase: useCase)
        return TimelineVC(viewModel: viewModel)
    }
    
    static func makeHomeVC() -> HomeVC {
        // TODO: - 서버 연결 후 Repository 변경
        let repository = PostingRepositoryMock()
        let useCase = HomeUseCaseImpl(repository: repository)
        let viewModel = HomeViewModel(homeUseCase: useCase)
        return HomeVC(viewModel: viewModel)
    }
    
    static func makeTimelineDetailVC(with id: String) -> TimelineDetailVC {
        // TODO: - 서버 연결 후 Rpository 변경
        let repository = TimelineDetailRepositoryMock()
        let useCase = TimelineDetailUseCaseImpl(repository: repository)
        let viewModel = TimelineDetailViewModel(timelineDetailUseCase: useCase, timelineId: id)
        return TimelineDetailVC(viewModel: viewModel)
    }
    
    static func makeMyPostListVC() -> MyPostListVC {
        let repository = PostingRepositoryMock()
        let useCase = MyPostListUseCaseImpl(repository: repository)
        let viewModel = MyPostListViewModel(myPostListUseCase: useCase)
        return MyPostListVC(viewModel: viewModel)
    }
    
    static func makeTravelVC() -> TravelVC {
//        let repository = TravelRepositoryMock()
        let repository = TravelRepositoryImpl(network: network)
        let useCase = TravelUseCaseImpl(repository: repository)
        let viewModel = TravelViewModel(travelUseCase: useCase)
        return TravelVC(viewModel: viewModel)
    }
    
    static func makeTimelineWritingVC() -> TimelineWritingVC {
        let repository = TimelineDetailRepositoryMock()
        let useCase = TimelineWritingUseCaseImpl(repository: repository)
        let viewModel = TimelineWritingViewModel(
            useCase: useCase,
            postId: "1234",
            date: "2022년 3월 5일",
            day: 1
        )
        return TimelineWritingVC(viewModel: viewModel)
    }
}
