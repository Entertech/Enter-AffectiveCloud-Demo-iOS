//
//  GuideView.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/5/12.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import SnapKit

class GuideView: BaseView {
    var message: String = "" {
        didSet {
            textLabel.text = message
            textLabel.setLine(space: 7)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(.dm, light: Colors.light.red5.HexToColor(), dark: Colors.dark.red5.HexToColor())
        closeButton.setImage(UIImage(.dm, light: #imageLiteral(resourceName: "icon_close"), dark: #imageLiteral(resourceName: "icon_close_dark")), for: .normal)
        closeButton.contentMode = .center
        
        textLabel.font = UIFont.systemFont(ofSize: 14)
        textLabel.textAlignment = .left
        textLabel.textColor = UIColor(.dm, light: Colors.light.red2.HexToColor(), dark: Colors.dark.red2.HexToColor())
        textLabel.numberOfLines = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let closeButton = UIButton(frame: CGRect.zero)

    private let textLabel = UILabel(frame: CGRect.zero)

    override func setup() {
        self.addSubview(textLabel)
        self.addSubview(closeButton)
    }

    override func layout() {
        textLabel.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.top.equalTo(8)
            $0.bottom.equalTo(-8)
            $0.right.equalTo(-32)
        }

        closeButton.snp.makeConstraints {
            $0.top.equalTo(4)
            $0.right.equalTo(-4)
            $0.height.width.equalTo(24)
        }
    }
}
