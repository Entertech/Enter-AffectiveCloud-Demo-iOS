//
//  TotalView.swift
//  Flowtime
//
//  Created by Enter on 2019/6/12.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class TotalView: BaseView {

    @IBOutlet weak var timeCountLabel: UILabel!
    @IBOutlet weak var lessonCountLabel: UILabel!
    @IBOutlet weak var daysCountLabel: UILabel!
    @IBOutlet weak var titleView: TitleView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func setup() {
        if let view = Nib.load(name: "TotalView", withOwner: self).view {
            self.addSubview(view)
            view.snp.makeConstraints {
                $0.right.left.top.bottom.equalToSuperview()
            }
            view.backgroundColor = Colors.bgZ1
        }
        self.backgroundColor = .clear
        
        self.layer.cornerRadius = 8
        titleView.iconImage = #imageLiteral(resourceName: "icon_report_total")
        titleView.titleText = "总计"
        titleView.isNeedBtn = false
        titleView.backgroundColor = Colors.bgZ1
    }

}
