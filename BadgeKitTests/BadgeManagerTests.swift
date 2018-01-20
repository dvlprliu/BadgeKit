//
//  BadgeManagerTests.swift
//  BadgeKitTests
//
//  Created by zhzh liu on 2018/1/17.
//  Copyright © 2018年 zhzh liu. All rights reserved.
//

import XCTest
@testable import BadgeKit


class BadgeManagerTests: XCTestCase {

    var manager: BadgeManager!
    
    override func setUp() {
        super.setUp()
        manager = BadgeManager.shared
    }
    
    override func tearDown() {
        manager = nil
        super.tearDown()
    }

    func testsManagerObserveUnobserve() {
        let infoA = "root.test.A".asBadgeInfo()
        let infoB = "root.test.B".asBadgeInfo()

        manager.observe(badgeInfo: infoA)
        manager.observe(badgeInfo: infoB)

        XCTAssertEqual(manager.numberOfInfos(with: infoA.keyPath), 1)
        XCTAssertEqual(manager.numberOfInfos(with: infoB.keyPath), 1)
    }

    func testManagerSetUnsetBadge() {
        let keypathI1A = "root.item1.a".asBadgeInfo()
        let keypathI1B = "root.item1.b".asBadgeInfo()
        let keypathI1C = "root.item1.c".asBadgeInfo()

        let keypathI2A = "root.item2.a".asBadgeInfo()
        let keypathI2B = "root.item2.b".asBadgeInfo()
        let keypathI2C = "root.item2.c".asBadgeInfo()

        manager.observe(badgeInfo: keypathI1A)
        manager.observe(badgeInfo: keypathI1B)
        manager.observe(badgeInfo: keypathI1C)

        manager.observe(badgeInfo: keypathI2A)
        manager.observe(badgeInfo: keypathI2B)
        manager.observe(badgeInfo: keypathI2C)

        manager.setBadge(for: keypathI1A.keyPath)
        manager.setBadge(for: keypathI1B.keyPath)
        manager.setBadge(for: keypathI1C.keyPath, count: 10)

        manager.setBadge(for: keypathI2A.keyPath)
        manager.setBadge(for: keypathI2B.keyPath)
        manager.setBadge(for: keypathI2C.keyPath, count: 10)

        let treeI1A = manager.badge(for: keypathI1A.keyPath)
        let treeI1B = manager.badge(for: keypathI1B.keyPath)
        let treeI1C = manager.badge(for: keypathI1C.keyPath)

        let treeI2A = manager.badge(for: keypathI2A.keyPath)
        let treeI2B = manager.badge(for: keypathI2B.keyPath)
        let treeI2C = manager.badge(for: keypathI2C.keyPath)

        XCTAssertNotNil(treeI1A)
        XCTAssertNotNil(treeI1B)
        XCTAssertNotNil(treeI1C)
        XCTAssertNotNil(treeI1A?.find({$0.name == "a"}))
        XCTAssertNil(treeI2A?.find({$0.name == "item1"}))
        XCTAssertNotNil(treeI1B?.find({$0.name == "b"}))
        XCTAssertNil(treeI2B?.find({$0.name == "item1"}))
        XCTAssertNotNil(treeI1C?.find({$0.name == "c"}))
        XCTAssertNil(treeI2C?.find({$0.name == "item1"}))
        XCTAssertEqual(treeI1A!.count, 1)
        XCTAssertEqual(treeI1B!.count, 1)
        XCTAssertEqual(treeI1C!.count, 1)

        XCTAssertEqual(manager.numberOfInfos(with: keypathI1A.keyPath), 1)
        XCTAssertEqual(manager.numberOfInfos(with: keypathI1B.keyPath), 1)
        XCTAssertEqual(manager.numberOfInfos(with: keypathI1C.keyPath), 1)
        XCTAssertEqual(manager.numberOfInfos(with: "invalid_keypath"), 0)


        manager.clearBadge(for: keypathI1A.keyPath)
        manager.clearBadge(for: keypathI1B.keyPath, forced: true)
        manager.clearBadge(for: "")
        manager.clearBadge(for: "invalid_keypath")

        let treeI1A_ = manager.badge(for: keypathI1A.keyPath)
        let treeI1B_ = manager.badge(for: keypathI1B.keyPath)

        XCTAssertNil(treeI1A_?.find({ $0.name == "a" }))
        XCTAssertNil(treeI1B_?.find({ $0.name == "b" }))
    }

    func testHierarchicalBadge() {
        let p0 = "root.item1"
        let p1 = "root.item1.A"
        let p2 = "root.item1.A.1"
        let p3 = "root.item1.B"
        let p4 = "root.item2.A"
        let keypaths = [p0,p1,p2,p3,p4]
        let badgeInfos = keypaths.map { $0.asBadgeInfo() }

        badgeInfos.forEach(manager.observe)
        manager.setBadge(for: p2, count: 1)

        XCTAssertEqual(manager.numberOfInfos(with: p1), 1)
        XCTAssertEqual(manager.numberOfInfos(with: "root"), 0)
        for keypath in [p0,p1,p2] {
            XCTAssertNotNil(manager.badge(for: keypath))
        }
        XCTAssertNil(manager.badge(for: p4))
        XCTAssertTrue(manager.badge(for: p0)!.value.shouldShow)
        XCTAssertTrue(manager.badge(for: p1)!.value.shouldShow)
        XCTAssertTrue(manager.badge(for: p2)!.value.shouldShow)
    }

    func testBadgePath() {
        let p = "root.item1.B.C.A"
        let p1 = "root.item2.B.C.C"
        manager.setBadge(for: p)
        let badge = manager.badge(for: p)
        let badge1 = manager.badge(for: p1)
        XCTAssertNil(badge1)
        XCTAssertNotNil(badge)
        XCTAssertEqual(badge!.value.name, "A")
        XCTAssertEqual(badge!.value.keypath, p)
        XCTAssertTrue(badge!.value.shouldShow)
    }
}

extension BadgeInfo {
    static func info(with keypath: String) -> BadgeInfo {
        let observer = NSObject()
        let controller = BadgeController(observer: observer)
        return BadgeInfo(keyPath: keypath, controller: controller, badgeView: nil)
    }
}

protocol BadgeInfoConvertable {
    func asBadgeInfo() -> BadgeInfo
}

extension String: BadgeInfoConvertable {
    func asBadgeInfo() -> BadgeInfo {
        return BadgeInfo.info(with: self)
    }
}

