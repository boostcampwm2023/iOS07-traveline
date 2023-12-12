//
//  TravelListSample.swift
//  traveline
//
//  Created by 김영인 on 2023/11/20.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

// TODO: - 추후에 서버 연동시 지우기
enum TravelListSample {
    static func makeTags() -> [Tag] {
        return [
            .init(title: "부산", type: .region),
            .init(title: "1박 2일", type: .period),
            .init(title: "봄", type: .season)
        ]
    }
    
    static func makeInfo() -> TravelListInfo {
        return
            .init(id: "1",
                  imageURL: "",
                  title: "부산여행",
                  profile: Profile(imageURL: "", name: "영인"),
                  like: 10,
                  isLiked: false,
                  tags: TravelListSample.makeTags()
            )
    }
    
    static func make() -> TravelList {
        return [
            .init(id: "1",
                  imageURL: "",
                  title: "부산여행",
                  profile: Profile(imageURL: "", name: "영인"),
                  like: 10,
                  isLiked: false,
                  tags: TravelListSample.makeTags()
                 ),
            .init(id: "2",
                  imageURL: "",
                  title: "속초여행",
                  profile: Profile(imageURL: "", name: "0inn"),
                  like: 20,
                  isLiked: true,
                  tags: TravelListSample.makeTags()
                 ),
            .init(id: "3",
                  imageURL: "",
                  title: "제주도여행",
                  profile: Profile(imageURL: "", name: "youngin"),
                  like: 30,
                  isLiked: true,
                  tags: TravelListSample.makeTags()
                 ),
            .init(id: "4",
                  imageURL: "",
                  title: "제주도여행",
                  profile: Profile(imageURL: "", name: "youngin"),
                  like: 30,
                  isLiked: false,
                  tags: TravelListSample.makeTags()
                 ),
            .init(id: "5",
                  imageURL: "",
                  title: "제주도여행",
                  profile: Profile(imageURL: "", name: "youngin"),
                  like: 30,
                  isLiked: true,
                  tags: TravelListSample.makeTags()
                 ),
            .init(id: "6",
                  imageURL: "",
                  title: "제주도여행",
                  profile: Profile(imageURL: "", name: "youngin"),
                  like: 0,
                  isLiked: false,
                  tags: TravelListSample.makeTags()
                 )
        ]
    }
}
