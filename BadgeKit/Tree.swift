//
//  Tree.swift
//  BadgeKit
//
//  Created by zhzh liu on 2018/1/17.
//  Copyright © 2018年 zhzh liu. All rights reserved.
//

import Foundation

internal final class Node<T> {
    var value: T
    var parent: Node<T>?
    var children: [Node<T>] = []

    init(value: T) {
        self.value = value
    }

    var isLeaf: Bool {
        return children.isEmpty
    }

    var isRoot: Bool {
        return parent == nil
    }

    var count: Int {
        return 1 + children.reduce(0) { (r, node) in
            r + node.count
        }
    }
}

extension Node where T: Hashable {

    func add(child value: T) {
        let node = Node(value: value)
        add(child: node)
    }

    func add(child node: Node<T>) {
        children.append(node)
        node.parent = self
    }

    func remove(value: T) {
        if let node = find(value: value) {
            node.remove()
        }
    }

    func remove() {
        if var siblins = self.parent?.children {
            if let idx = siblins.index(where: { $0.value == self.value }) {
                siblins.remove(at: idx)
                parent?.children = siblins
                self.parent = nil
            }
        }
    }

    func find(value: T) -> Node<T>? {
        if self.value == value {
            return self
        }
        for child in children {
            if let found = child.find(value: value) {
                return found
            }
        }
        return nil
    }

    func find(_ predicate: (T) -> Bool) -> Node<T>? {
        if predicate(self.value) { return self }
        for child in children {
            if let found = child.find(predicate) {
                return found
            }
        }
        return nil
    }
}

extension Node: CustomDebugStringConvertible {
    var debugDescription: String {
        var s = "\(value)"
        if !children.isEmpty {
            s += " {" + children.map { $0.debugDescription }.joined(separator: ", ") + "}"
        }
        return s
    }
}

extension BadgeModel {
    static var root: BadgeModel {
        return BadgeModel(name: "root", keypath: "root", count: 0, shouldShow: false)
    }
}

