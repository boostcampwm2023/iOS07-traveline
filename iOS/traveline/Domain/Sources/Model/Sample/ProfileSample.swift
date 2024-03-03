//
//  ProfileSample.swift
//  traveline
//
//  Created by 김영인 on 2023/11/30.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum ProfileSample {
    static func make() -> Profile {
        .init(
            imageURL: "https://avatars.githubusercontent.com/u/74968390?v=4",
            imagePath: "https://avatars.githubusercontent.com/u/74968390?v=4",
            name: "0inn"
        )
    }
}
