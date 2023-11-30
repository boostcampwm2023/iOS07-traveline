//
//  TimelineDetailViewModel.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/11/30.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

enum TimelineDetailAction: BaseAction {
    case viewDidLoad
}

enum TimelineDetailSideEffect: BaseSideEffect {
    case loadTimelineDetail(TimelineDetailInfo)
    
}

struct TimelineDetailState: BaseState {
    var timelineDetailInfo: TimelineDetailInfo = .init(
        id: Literal.empty,
        title: Literal.empty,
        day: 1,
        description: Literal.empty,
        date: Literal.empty,
        time: Literal.empty
    )
}

final class TimelineDetailViewModel: BaseViewModel<TimelineDetailAction, TimelineDetailSideEffect, TimelineDetailState> {
    
    private let id: String
    
    init(timelineId: String) {
        self.id = timelineId
    }
    
    override func transform(action: Action) -> SideEffectPublisher {
        switch action {
        case .viewDidLoad:
            return loadTimelineDetailInfo()
        }
    }

    override func reduceState(state: State, effect: SideEffect) -> State {
        var newState = state
        
        switch effect {
        case .loadTimelineDetail(let info):
            newState.timelineDetailInfo = info
        }
        
        return newState
    }
}

private extension TimelineDetailViewModel {
    func loadTimelineDetailInfo() -> SideEffectPublisher {
        // TODO: - 타임라인디테일 요청 로직 변경하기
        let info = TimelineDetailInfo(
            id: "ae12a997-159c-40d1-b3c6-62af7fd981d1",
            title: "두근두근 출발 날 😍",
            day: 1,
            description: "서울역의 상징성은 정치적으로도 연관이 깊다. 이는 신의 한 수가 된다. 영서 지방은 ITX-청춘 용산발 춘천행, DMZ-train 서울발 백마고지행 둘뿐이었다.",
            imageURL: "https://user-images.githubusercontent.com/51712973/280571628-e1126b86-4941-49fc-852b-9ce16f3e0c4e.jpg",
            date: "2023-08-16",
            location: "서울역",
            time: "07:30"
        )
        
        return .just(TimelineDetailSideEffect.loadTimelineDetail(info))
    }
}
