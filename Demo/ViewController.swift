//
//  ViewController.swift
//  Demo
//
//  Created by zhzh liu on 2018/1/18.
//  Copyright © 2018年 zhzh liu. All rights reserved.
//

import UIKit
import BadgeKit

class ViewController: UIViewController {

    @IBOutlet weak var v0: UIView!
    @IBOutlet weak var v1: UIView!
    @IBOutlet weak var v2: UIView!
    @IBOutlet weak var v3: UIView!
    @IBOutlet weak var v4: UIView!
    @IBOutlet weak var v5: UIView!

    var show = false

    let v1path = "root.v1"
    let v2path = "root.v1.v2"
    let v3path = "root.v1.v2.v3"
    let v4path = "root.v1.v2.v4"

    override func viewDidLoad() {
        super.viewDidLoad()

        badgeController?.observe(keypath: v1path, badgeView: v1)
        badgeController?.observe(keypath: v2path, badgeView: v2)
        badgeController?.observe(keypath: v3path, badgeView: v3)
        badgeController?.observe(keypath: v4path, badgeView: v4)

        BadgeController.setBadge(for: v4path)

    }

    @IBAction func refresh(_ sender: Any) {
        showAllBadge()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAllBadge()
    }

    func showAllBadge() {
        if show {
            BadgeController.setBadge(for: v3path, count: 8)
        } else {
            BadgeController.clearBadge(for: v3path)
        }
        show = !show
    }
}
