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
        let repository = TimelineRepositoryImpl(network: network)
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
    
}
