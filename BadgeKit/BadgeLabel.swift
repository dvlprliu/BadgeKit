//
//  BadgeLabel.swift
//  BadgeKit
//
//  Created by zhzh liu on 2018/1/19.
//  Copyright © 2018年 zhzh liu. All rights reserved.
//

import UIKit

public class BadgeLabel: UILabel {

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been oimplemented")
    }


    static var `default`: BadgeLabel {
        return BadgeLabel(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
    }

    private func setupUI() {
        self.textColor = UIColor.white
        self.font = UIFont.systemFont(ofSize: 13)
        self.textAlignment = NSTextAlignment.center
        self.layer.cornerRadius = self.frame.height * 0.5
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.init(red: 1.00, green: 0.17, blue: 0.15, alpha: 1.0)
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let exactSize = super.sizeThatFits(size)
        return CGSize(width: exactSize.width + 2 * 5, height: exactSize.height + 2 * 2)
    }

}
