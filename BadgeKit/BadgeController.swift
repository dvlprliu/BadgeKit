//
//  BadgeController.swift
//  BadgeKit
//
//  Created by zhzh liu on 2018/1/16.
//  Copyright © 2018年 zhzh liu. All rights reserved.
//

import Foundation

private var BadgeControllerKey = "BadgeControllerKey"
public extension NSObject {
    public var badgeController: BadgeController? {
        get {
            if let controller =  objc_getAssociatedObject(self, &BadgeControllerKey) as? BadgeController {
                return controller
            }
            let controller = BadgeController(observer: self)
            self.badgeController = controller
            return controller
        }
        set {
            objc_setAssociatedObject(self, &BadgeControllerKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

final public class BadgeController: NSObject {

    private let observer: Any
    private var infoSet: Set<BadgeInfo>
    private let lock: NSRecursiveLock

    init(observer: Any) {
        self.observer = observer
        self.infoSet = Set<BadgeInfo>()
        self.lock = NSRecursiveLock()
    }

    deinit {
        unobserveAll()
    }

    public func observe(keypath: String, badgeView: BadgeContainer?) {
        if keypath.isEmpty { return }
        let info = BadgeInfo(keyPath: keypath, controller: self, badgeView: badgeView)
        observe(with: info)
    }

    public func unobserve(keypath: String) {
        if keypath.isEmpty { return }
        let info = BadgeInfo(keyPath: keypath, controller: self, badgeView: nil)
        unobserve(with: info)
    }

    public func unobserveAll() {
        infoSet.forEach { (info) in
            self.unobserve(with: info)
        }
    }

    public static func setBadge(`for` keypath: String, count: Int = 0) {
        if keypath.isEmpty { return }
        BadgeManager.shared.setBadge(for: keypath, count: count)
    }

    public static func clearBadge(`for` keypath: String, force: Bool = false) {
        if keypath.isEmpty { return }
        BadgeManager.shared.clearBadge(for: keypath, forced: force)
    }

    private func observe(with info: BadgeInfo) {
        lock.lock(); defer { lock.unlock() }

        if infoSet.contains(info) { return }
        infoSet.insert(info)
        BadgeManager.shared.observe(badgeInfo: info)
    }

    private func unobserve(with info: BadgeInfo) {
        lock.lock(); defer { lock.unlock() }

        if infoSet.contains(info) { infoSet.remove(info) }
        BadgeManager.shared.unobserve(badgeInfo: info)
    }

    // Just for testing
    internal func numberOfInfos() -> Int {
        return infoSet.count
    }

    internal func containsKeypath(keypath: String) -> Bool {
        let info = BadgeInfo(keyPath: keypath, controller: self, badgeView: nil)
        return infoSet.contains(info)
    }

}


