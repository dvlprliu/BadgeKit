//
//  BadgeControllerTests.swift
//  BadgeKitTests
//
//  Created by zhzh liu on 2018/1/17.
//  Copyright © 2018年 zhzh liu. All rights reserved.
//

import XCTest
@testable import BadgeKit

class BadgeControllerTests: XCTestCase {

    var observer: NSObject!
    var controller: BadgeController!
    var manager: BadgeManager!
    
    override func setUp() {
        super.setUp()
        observer = NSObject()
        controller = BadgeController(observer: observer)
        manager = BadgeManager.shared
    }
    
    override func tearDown() {
        observer = nil
        controller = nil
        manager = nil
        super.tearDown()
    }

    // 测试observe的可用性
    func testBadgeControllerCoundObserve() {

        let keypath = "test.observe"
        let keypath_not_contained = "not_contained"

        controller.observe(keypath: keypath, badgeView: nil)
        XCTAssertEqual(controller.numberOfInfos(), 1)
        XCTAssert(controller.containsKeypath(keypath: keypath), "should contains keypath : \(keypath)")
        XCTAssertFalse(controller.containsKeypath(keypath: keypath_not_contained))
    }

    // 测试unobserve的可用性
    func testBadgeControllerCoundUnobserve() {

        let keypath_a = "test.observe.a"
        let keypath_b = "test.observe.b"
        let keypath_not_contained = "not_contained"

        controller.observe(keypath: keypath_a, badgeView: nil)
        controller.observe(keypath: keypath_b, badgeView: nil)
        XCTAssertEqual(controller.numberOfInfos(), 2)
        XCTAssertTrue(controller.containsKeypath(keypath: keypath_a))
        XCTAssertTrue(controller.containsKeypath(keypath: keypath_b))
        XCTAssertFalse(controller.containsKeypath(keypath: keypath_not_contained))

        controller.unobserve(keypath: keypath_a)
        XCTAssertEqual(controller.numberOfInfos(), 1)
        XCTAssertTrue(controller.containsKeypath(keypath: keypath_b))
        XCTAssertFalse(controller.containsKeypath(keypath: keypath_a))
        XCTAssertFalse(controller.containsKeypath(keypath: keypath_not_contained))

        controller.unobserve(keypath: keypath_b)
        XCTAssertEqual(controller.numberOfInfos(), 0)
        XCTAssertFalse(controller.containsKeypath(keypath: keypath_b))
        XCTAssertFalse(controller.containsKeypath(keypath: keypath_a))
        XCTAssertFalse(controller.containsKeypath(keypath: keypath_not_contained))
    }

    func testBadgeControllerUnobserveAll() {

        let keypath_a = "test.observe.a"
        let keypath_b = "test.observe.b"
        let keypath_not_contained = "not_contained"

        controller.observe(keypath: keypath_a, badgeView: nil)
        controller.observe(keypath: keypath_b, badgeView: nil)
        XCTAssertEqual(controller.numberOfInfos(), 2)
        XCTAssertTrue(controller.containsKeypath(keypath: keypath_a))
        XCTAssertTrue(controller.containsKeypath(keypath: keypath_b))
        XCTAssertFalse(controller.containsKeypath(keypath: keypath_not_contained))

        controller.unobserveAll()
        XCTAssertEqual(controller.numberOfInfos(), 0)
        XCTAssertFalse(controller.containsKeypath(keypath: keypath_b))
        XCTAssertFalse(controller.containsKeypath(keypath: keypath_a))
        XCTAssertFalse(controller.containsKeypath(keypath: keypath_not_contained))

    }

    // 没有重复的keypath
    func testBadgeControllerObserveDistinct() {
        // setup
        let keypath = "test.observe"
        let keypath_copy = "test.observe"
        // when given
        controller.observe(keypath: keypath, badgeView: nil)
        controller.observe(keypath: keypath_copy, badgeView: nil)
        // it should
        XCTAssertEqual(controller.numberOfInfos(), 1)
        XCTAssertTrue(controller.containsKeypath(keypath: keypath))
    }

    func testBadgeControllerDoNotObserveEmptyKeypath() {
        let emptyKeypath = ""
        let keypathA = "observe.keypath.a"
        let keypathB = "Observe.keypath.b"
        // when given
        controller.observe(keypath: keypathA, badgeView: nil)
        controller.observe(keypath: keypathB, badgeView: nil)
        controller.observe(keypath: emptyKeypath, badgeView: nil)
        // it should
        XCTAssertEqual(controller.numberOfInfos(), 2)
        XCTAssertTrue(controller.containsKeypath(keypath: keypathA))
        XCTAssertTrue(controller.containsKeypath(keypath: keypathB))
        XCTAssertFalse(controller.containsKeypath(keypath: emptyKeypath))

    }

    func testBadgeControllerDoNotUnobserveEmptykeypath() {
        let emptyKeypath = ""
        let keypathA = "observe.keypath.a"
        let keypathB = "Observe.keypath.b"
        // when given
        controller.observe(keypath: keypathA, badgeView: nil)
        controller.observe(keypath: keypathB, badgeView: nil)
        controller.observe(keypath: emptyKeypath, badgeView: nil)
        // it should
        XCTAssertEqual(controller.numberOfInfos(), 2)
        XCTAssertTrue(controller.containsKeypath(keypath: keypathA))
        XCTAssertTrue(controller.containsKeypath(keypath: keypathB))
        XCTAssertFalse(controller.containsKeypath(keypath: emptyKeypath))
        // then
        controller.unobserve(keypath: emptyKeypath)
        // it should has no effect
        XCTAssertEqual(controller.numberOfInfos(), 2)
        XCTAssertTrue(controller.containsKeypath(keypath: keypathA))
        XCTAssertTrue(controller.containsKeypath(keypath: keypathB))
        XCTAssertFalse(controller.containsKeypath(keypath: emptyKeypath))

    }

    // helper
    private func keypath(i: Int) -> String {
        return "observe.keypath.\(i)"
    }
    
}
