//
//  BadgeView.swift
//  BadgeKit
//
//  Created by zhzh liu on 2018/1/17.
//  Copyright © 2018年 zhzh liu. All rights reserved.
//

import UIKit

public protocol BadgeContainer: class {
    var badge:          BadgeLabel { get }
    var badgeImage:     UIImage? { get }

    var badgeRadius: CGFloat { get }
    var badgeOffset: CGPoint { get }

    func hideBadge()
    func showBadge()
    func showBadge(with value: UInt)
}


