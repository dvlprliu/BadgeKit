//
//  BadgeTreeTests.swift
//  BadgeKitTests
//
//  Created by zhzh liu on 2018/1/17.
//  Copyright © 2018年 zhzh liu. All rights reserved.
//

import XCTest
@testable import BadgeKit


class BadgeTreeTests: XCTestCase {

    typealias TestTree = Node<Int>

    var tree: TestTree!
    
    override func setUp() {
        super.setUp()
        tree = TestTree(value: 0)
    }
    
    override func tearDown() {
        tree = nil
        super.tearDown()
    }

    func testTreeAdd() {
        let node1 = Array(10...15).map(TestTree.init)
        let node2 = Array(15...20).map(TestTree.init)
        let tree1 = TestTree(value: 1)
        let tree2 = TestTree(value: 2)
        node1.forEach { (node) in
            tree1.add(child: node)
        }
        node2.forEach { (node) in
            tree2.add(child: node)
        }
        tree.add(child: tree1)
        tree.add(child: tree2)

        debugPrint(tree)

        XCTAssertEqual(tree.count, node1.count + node2.count + 3)
        XCTAssertTrue(tree.isRoot)
        XCTAssertNotNil(tree.children)
        XCTAssertEqual(tree.children.count, 2)
        XCTAssertNil(tree.parent)
        XCTAssertNotNil(tree2.parent)
        XCTAssertNotNil(tree1.parent)
        XCTAssertNotNil(tree.find(value: 1))
        XCTAssertNotNil(tree.find(value: 2))
        XCTAssertNotNil(tree.find(value: 10))
        XCTAssertNotNil(tree.find(value: 15))
    }

    func testTreeRemove() {
        let node1 = Array(10...15).map(TestTree.init)
        let node2 = Array(15...20).map(TestTree.init)
        let tree1 = TestTree(value: 1)
        let tree2 = TestTree(value: 2)
        node1.forEach { (node) in
            tree1.add(child: node)
        }
        node2.forEach { (node) in
            tree2.add(child: node)
        }

        tree.add(child: tree1)
        tree.add(child: tree2)
        let count = node2.count + node1.count + 3
        XCTAssertEqual(tree.count, count)
        XCTAssertTrue(tree.isRoot)
        XCTAssertNotNil(tree.children)
        XCTAssertNil(tree.parent)
        XCTAssertNotNil(tree.find(value: 1))
        XCTAssertNotNil(tree.find(value: 2))
        XCTAssertNotNil(tree.find(value: 10))
        XCTAssertNotNil(tree.find(value: 15))
        XCTAssertNil(tree.find(value: 100))

        // remove a node that not in the tree
        tree.remove(value: 100)
        // it should
        XCTAssertEqual(tree.count, count)

        // when remove a leaf
        tree.remove(value: 10)
        // is should
        XCTAssertEqual(tree.count, count - 1)
        XCTAssertNil(tree.find(value: 10))

        // when remove a subtree
        tree1.remove()
        XCTAssertEqual(tree.count, count - tree1.count - 1)
        XCTAssertNil(tree.find(value: 1))
        XCTAssertNil(tree.find(value: 13))
        XCTAssertNotNil(tree.find(value: 17))
        XCTAssertNotNil(tree.find(value: 2))
    }

    func initialCase() {
        
    }


}
