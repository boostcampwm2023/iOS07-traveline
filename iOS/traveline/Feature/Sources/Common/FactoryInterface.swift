//
//  FactoryInterface.swift
//  Feature
//
//  Created by 김영인 on 4/14/24.
//

import Foundation
import Domain

public protocol FactoryInterface {
    func makeAutoLoginVC() -> AutoLoginVC
    func makeLoginVC() -> LoginVC
    func makeRootContainerVC() -> RootContainerVC
    func makeTimelineVC(id: TravelID) -> TimelineVC
    func makeHomeVC() -> HomeVC
    func makeTimelineDetailVC(with id: String) -> TimelineDetailVC
    func makeMyPostListVC() -> MyPostListVC
    func makeTravelVC(
        id: TravelID?,
        travelInfo: TimelineTravelInfo?
    ) -> TravelVC
    func makeTimelineWritingVC(
        id: TravelID,
        date: String,
        day: Int,
        timelineDetailInfo: TimelineDetailInfo?
    ) -> TimelineWritingVC
    func makeSideMenuVC() -> SideMenuVC
    func makeSettingVC() -> SettingVC
    func makeProfileEditingVC() -> ProfileEditingVC
}
