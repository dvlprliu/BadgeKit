//
//  BadgeManager.swift
//  BadgeKit
//
//  Created by zhzh liu on 2018/1/17.
//  Copyright © 2018年 zhzh liu. All rights reserved.
//

import Foundation

internal final class BadgeManager {

    typealias BadgeInfoSet = Set<BadgeInfo>
    typealias BadgeTree = Node<BadgeModel>

    static let shared: BadgeManager = BadgeManager()

    private let tree: BadgeTree
    private var objInfoMap: [String: BadgeInfoSet]
    private let _lock: NSRecursiveLock

    private init() {
        _lock = NSRecursiveLock()
        tree = Node(value: BadgeModel.root)
        objInfoMap = [:]
    }

    func observe(badgeInfo: BadgeInfo) {
        let info = badgeInfo
        let keypath = info.keyPath
        var infos = objInfoMap[keypath, default: BadgeInfoSet()]
        infos.insert(info)
        objInfoMap[keypath] = infos
        if let badge = self.badge(for: keypath), badge.value.shouldShow {
            statusChange(for: badge)
        }
    }

    func unobserve(badgeInfo: BadgeInfo) {
        let info = badgeInfo
        let keypath = info.keyPath
        var infoSet = objInfoMap[keypath]
        if infoSet?.contains(info) ?? false {
            let badgeView = badgeInfo.badgeView
            badgeView?.hideBadge()
            infoSet?.remove(badgeInfo)
            if infoSet?.isEmpty ?? false {
                objInfoMap[keypath] = nil
            }
        }
    }

    // 构建树结构
    func setBadge(`for` keypath: String, count: Int = 0) {
        if keypath.isEmpty { return }

        let keypathComponent = keypath.components(separatedBy: ".")
        var root = self.tree
        var mBadge:BadgeTree?

        for name in keypathComponent {
            if name == "root" { continue }
            var found = root.findChild(with: name)
            let namePath = ".\(name)"
            let subKeypath = root.value.keypath + namePath
            if found == nil {
                let set = name == keypathComponent.last
                let badge = BadgeModel(name: name, keypath: subKeypath, count: 0, shouldShow: set)
                found = Node(value: badge)
                root.add(child: found!)
            }

            root = found!

            if subKeypath == keypath {
                found?.value.shouldShow = true
                found?.value.count = count
                mBadge = found
            }
        }

        if let badge = mBadge {
            badge.updateShouldShow()
            statusChange(for: badge)
        }
    }

    func clearBadge(`for` keypath: String, forced: Bool = false) {
        if keypath.isEmpty { return }

        let keypathComponent = keypath.components(separatedBy: ".")
        var root = self.tree

        for name in keypathComponent {
            if name == "root" { continue }
            let found = root.findChild(with: name)
            guard let aFound = found else { return }
            root = aFound
            if name == keypathComponent.last {
                aFound.value.shouldShow = false
                if aFound.isLeaf || forced {
                    aFound.value.count = 0
                    aFound.updateShouldShow()
                    statusChange(for: aFound)
                    aFound.remove()
                }
            }
        }
    }

    internal func badge(`for` keypath: String) -> BadgeTree? {
        let keypathComponent = keypath.components(separatedBy: ".")
        var badge:BadgeTree?
        var tree: BadgeTree = self.tree
        for name in keypathComponent {
            if name == "root" { continue }
            if let idx = tree.children.index(where: { $0.value.name == name }) {
                badge = tree.children[idx]
                tree = tree.children[idx]
            }
        }
        return badge
    }

    private func statusChange(`for` tree:BadgeTree) {
        let badge = tree.value
        let path = badge.keypath
        if path == "root" { return }
        let infos = objInfoMap[path]
        infos?.forEach({ (info) in
            let badgeView = info.badgeView
            let count = badge.count
            if count > 0 {
                badgeView?.showBadge(with: UInt(count))
            } else if badge.shouldShow {
                badgeView?.showBadge()
            } else {
                badgeView?.hideBadge()
            }
        })

        if let parent = tree.parent {
            statusChange(for: parent)
        }
    }

    // just for testing
    internal func numberOfInfos(with keypath: String) -> Int {
        let infos = objInfoMap[keypath]
        return infos?.count ?? 0
    }
}

extension Node where T: BadgeModel {

    func findChild(with name: String) -> Node<T>? {
        if children.isEmpty { return nil }
        return children.filter { (node) -> Bool in
            node.value.name == name
        }.first
    }

    func updateShouldShow() {
        guard let parent = self.parent else { return }
        parent.value.shouldShow = parent.shouldShowBadge()
        parent.updateShouldShow()
    }
    // if any of its child is showing a badge
    // this node should also shows a badge
    func shouldShowBadge() -> Bool {
        if children.isEmpty { return false }
        return children.reduce(false) { (result, node) in
            result || node.value.shouldShow
        }
    }
}

