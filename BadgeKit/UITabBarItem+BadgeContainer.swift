//
//  UITabBarItem+BadgeContainer.swift
//  BadgeKit
//
//  Created by zhzh liu on 2018/1/20.
//  Copyright © 2018年 zhzh liu. All rights reserved.
//

import UIKit

extension UITabBarItem: BadgeContainer {

    public var badge: BadgeLabel {
        get {
            return _bottomView.badge
        }
        set {
            _bottomView.badge = newValue
        }
    }

    public var badgeFont: UIFont {
        get {
            return _bottomView.badge.font
        }
        set {
            _bottomView.badgeFont = newValue
        }
    }

    public var badgeTextColor: UIColor {
        get {
            return _bottomView.badgeTextColor
        }
        set {
            _bottomView.badgeTextColor = newValue
        }
    }

    public var customView: UIView? {
        get {
            return _bottomView.customView
        }
        set {
            _bottomView.customView = newValue
        }
    }

    public var badgeImage: UIImage? {
        get {
            return _bottomView.badgeImage
        }
        set {
            _bottomView.badgeImage = newValue
        }
    }

    public var badgeRadius: CGFloat {
        get {
            return _bottomView.badgeRadius
        }
        set {
            _bottomView.badgeRadius = newValue
        }
    }

    public var badgeOffset: CGPoint {
        get {
            return _bottomView.badgeOffset
        }
        set {
            _bottomView.badgeOffset = newValue
        }
    }

    public func hideBadge() {
        _bottomView.hideBadge()
    }

    public func showBadge() {
        _bottomView.showBadge()
    }

    public func showBadge(with value: UInt) {
        _bottomView.showBadge(with: value)
    }

    private var _bottomView: UIView {
        let tabBarButton = (self.value(forKey: "_view") as? UIView) ?? UIView()
        for subView in tabBarButton.subviews {
            if NSStringFromClass(subView.superclass!) == "UIImageView" {
                return subView
            }
        }
        return tabBarButton
    }

}
