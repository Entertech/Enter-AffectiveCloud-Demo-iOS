//
//  StreakView.swift
//  Flowtime
//
//  Created by Enter on 2019/6/12.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class StreakView: BaseView {

    @IBOutlet weak var streakDateView: StreakDateView!
    @IBOutlet weak var titleView: TitleView!
    @IBOutlet weak var longestStreakLabel: UILabel!
    @IBOutlet weak var currentStreakLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func setup() {
        if let view = Nib.load(name: "StreakView", withOwner: self).view {
            self.addSubview(view)
            view.snp.makeConstraints {
                $0.right.left.top.bottom.equalToSuperview()
            }
            view.backgroundColor = Colors.bgZ1
        }
        self.backgroundColor = .clear   
        self.layer.cornerRadius = 8
        titleView.iconImage = #imageLiteral(resourceName: "icon_report_streak")
        titleView.titleText = "Streak"
        titleView.isNeedBtn = false
        titleView.backgroundColor = Colors.bgZ1
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
