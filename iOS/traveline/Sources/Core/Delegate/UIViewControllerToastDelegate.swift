//
//  UIViewControllerToastDelegate.swift
//  traveline
//
//  Created by 김태현 on 1/24/24.
//  Copyright © 2024 traveline. All rights reserved.
//

import Foundation

protocol UIViewControllerToastDelegate: AnyObject {
    func viewControllerDidFinishAction(isSuccess: Bool, message: String)
}
