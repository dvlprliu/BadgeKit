//
//  BadgeInfo.swift
//  BadgeKit
//
//  Created by zhzh liu on 2018/1/17.
//  Copyright © 2018年 zhzh liu. All rights reserved.
//

import Foundation

internal final class BadgeInfo {
    let keyPath: String
    let controller: BadgeController
    let badgeView: BadgeContainer?

    init(keyPath: String, controller: BadgeController, badgeView: BadgeContainer?) {
        self.keyPath = keyPath
        self.controller = controller
        self.badgeView = badgeView
    }
}

extension BadgeInfo: Hashable {
    static func ==(lhs: BadgeInfo, rhs: BadgeInfo) -> Bool {
        // FIXME: equal logic
        return lhs.keyPath == rhs.keyPath
            && lhs.controller === rhs.controller
    }

    var hashValue: Int {
        return keyPath.hashValue ^ controller.hashValue
    }
}
