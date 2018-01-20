//
//  UIView+BadgeContainer.swift
//  BadgeKit
//
//  Created by zhzh liu on 2018/1/20.
//  Copyright © 2018年 zhzh liu. All rights reserved.
//

import UIKit

private struct BadgeViewAssociateKeys {
    static var label: String = "BadgeKit.BadgeView.Badge"
    static var radius: String = "BadgeKit.BadgeView.BadgeRadius"
    static var offset: String = "BadgeKit.BadgeView.BadgeOffset"
    static var badgeFont: String = "BadgeKit.BadgeView.BadgeFont"
    static var badgeTextColor: String = "BadgeKit.BadgeView.BadgeTextColor"
    static var customView: String = "BadgeKit.BadgeView.CustomView"
    static var badgeImage: String = "BadgeKit.BadgeView.badgeImage"
}

extension UIView: BadgeContainer {
    public var badgeTextColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &BadgeViewAssociateKeys.badgeTextColor) as? UIColor {
                return color
            }
            return .red
        }
        set {
            objc_setAssociatedObject(self, &BadgeViewAssociateKeys.badgeTextColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var badge: BadgeLabel {
        get {
            if let label = objc_getAssociatedObject(self, &BadgeViewAssociateKeys.label) as? BadgeLabel {
                return label
            }
            let label = BadgeLabel.default
            label.textAlignment = .center
            label.textColor = .white
            label.layer.masksToBounds = true
            label.isHidden = true
            self.addSubview(label)
            self.bringSubview(toFront: label)
            self.badge = label
            return label
        }
        set {
            objc_setAssociatedObject(self, &BadgeViewAssociateKeys.label, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var badgeRadius: CGFloat {
        get {
            if let radius = objc_getAssociatedObject(self, &BadgeViewAssociateKeys.radius) as? CGFloat {
                return radius
            }
            return 3.0
        }
        set {
            objc_setAssociatedObject(self, &BadgeViewAssociateKeys.radius, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }

    }

    public var badgeOffset: CGPoint {
        get {
            if let offset = objc_getAssociatedObject(self, &BadgeViewAssociateKeys.offset) as? NSValue {
                return offset.cgPointValue
            }
            return CGPoint.zero
        }
        set {

            objc_setAssociatedObject(self, &BadgeViewAssociateKeys.offset, NSValue(cgPoint: newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var badgeFont: UIFont {
        get {
            return self.badge.font
        }
        set {
            self.badge.font = newValue
        }
    }

    public var customView: UIView? {
        get {
            return objc_getAssociatedObject(self, &BadgeViewAssociateKeys.customView) as? UIView
        }
        set {
            if self.customView == newValue { return }
            if let view = self.customView, view.superview != nil {
                view.removeFromSuperview()
            }
            if let view = customView {
                self.addSubview(view)
            }

            objc_setAssociatedObject(self, &BadgeViewAssociateKeys.customView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public var badgeImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &BadgeViewAssociateKeys.badgeImage) as? UIImage
        }
        set {
            objc_setAssociatedObject(self, &BadgeViewAssociateKeys.badgeImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func hideBadge() {
        if let customView = self.customView {
            customView.isHidden = true
        }
        self.badge.isHidden = true
    }

    public func showBadge() {

        if let customView = self.customView {
            customView.isHidden = false
            badge.isHidden = true
            return
        }

        let radius = self.badgeRadius
        let width: CGFloat = radius * 2
        let rect = CGRect(x: self.frame.width - radius, y: -radius, width: width, height: width)
        let offsetX = frame.width + badgeOffset.x

        badge.frame = rect
        badge.text = nil
        badge.isHidden = false
        badge.layer.cornerRadius = badge.frame.width / 2.0
        badge.center = CGPoint(x: offsetX, y: badgeOffset.y)

    }

    public func showBadge(with value: UInt) {
        customView?.isHidden = true

        badge.isHidden = (value == 0)
        badge.font = self.badgeFont
        // FIXME: make it a property
        let max = 9
        badge.text = value <= max ? "\(value)" : "\(max)+"
        badge.sizeToFit()

        let offsetX = frame.width + 2 + badgeOffset.x
        badge.center = CGPoint(x: offsetX, y: badgeOffset.y)
        badge.layer.cornerRadius = badge.frame.height * 0.5
    }

}
