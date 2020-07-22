//
//  StreakDateView.swift
//  Flowtime
//
//  Created by Enter on 2019/6/12.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class StreakDateView: UIView {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var sundayLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        if let view = Nib.load(name: "StreakDateView", withOwner: self).view {
            self.addSubview(view)
            view.snp.makeConstraints {
                $0.right.left.top.bottom.equalToSuperview()
            }
            view.backgroundColor = .clear
        }
        self.backgroundColor = .clear
        self.layer.cornerRadius = 8
        let format = DateFormatter()
        format.dateFormat = "MMM. yyyy"
        let dateStr = format.string(from: Date())
        monthLabel.text = dateStr
    }
    private var dateIndexInMonth: [Bool] = Array(repeating: false, count: 31)
    var dateStreak: [Date]? {
        didSet {
            if let data = dateStreak {
                for e in data {
                    let index = e.whichDayInMonth()
                    dateIndexInMonth[index] = true
                }
                self.setNeedsDisplay()
            }
            
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let firstDayInWeek = Date.firstWeekDay()
        let daysInMonth = Date.countOfDaysInMonth()
        let width = sundayLabel.bounds.width
        let hight:CGFloat = 20
        let originY:CGFloat = 25
        let originX = sundayLabel.frame.origin.x
        let context = UIGraphicsGetCurrentContext()!
        for i in 0..<daysInMonth {
            let row = (i+firstDayInWeek) / 7
            let column = (i+firstDayInWeek) % 7
            let rect = CGRect(x: originX+(CGFloat(column)*CGFloat(width+1)),
                              y: originY+(CGFloat(row)*CGFloat(hight+1)),
                              width: width,
                              height: hight)

            if dateIndexInMonth[i] {
                context.setFillColor(Colors.bluePrimary.cgColor)
            } else {
                context.setFillColor(Colors.blue5.cgColor)
            }
            context.fill(rect)
            context.strokePath()
        }
    }
    

}
