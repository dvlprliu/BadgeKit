//
//  BadgeModel.swift
//  BadgeKit
//
//  Created by zhzh liu on 2018/1/17.
//  Copyright © 2018年 zhzh liu. All rights reserved.
//

import Foundation

internal protocol Badge: Hashable {
    var name: String { get }
    var keypath: String { get }
    var count: Int { get }
    var shouldShow: Bool { get }
}

extension Badge {
    var hashValue: Int {
        return name.hashValue ^ keypath.hashValue
    }
}
internal final class BadgeModel: Badge {

    var name: String
    var keypath: String
    var count: Int
    var shouldShow: Bool

    init(name: String, keypath: String, count: Int, shouldShow: Bool) {
        self.name = name
        self.keypath = keypath
        self.count = count
        self.shouldShow = shouldShow
    }
}

extension BadgeModel {
    static func ==(lhs: BadgeModel, rhs: BadgeModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension BadgeModel: CustomStringConvertible {
    var description: String {
        return "< name: \(name), keypath: \(keypath), count: \(count), shouldShow: \(shouldShow) >"
    }
}

