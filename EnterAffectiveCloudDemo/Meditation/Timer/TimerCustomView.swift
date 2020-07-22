//
//  TimerCustomView.swift
//  Flowtime
//
//  Created by Enter on 2020/6/12.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit

class TimerCustomView: UIControl {

    var bIsSelected = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    let largeCustomLabel = UILabel()
    let timerLabel = UILabel()
    let smallCustomLable = UILabel()
    private func setUI() {
        self.backgroundColor = Colors.bgZ2
        
        self.addSubview(largeCustomLabel)
        self.addSubview(smallCustomLable)
        self.addSubview(timerLabel)

        
        largeCustomLabel.text = "自定义"
        largeCustomLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        largeCustomLabel.textAlignment = .center
        largeCustomLabel.textColor = Colors.textLv1
        
        smallCustomLable.text = "自定义"
        smallCustomLable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        smallCustomLable.textAlignment = .center
        smallCustomLable.textColor = .white
        smallCustomLable.isHidden = true
        
        timerLabel.text = "88时00分"
        timerLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        timerLabel.textAlignment = .center
        timerLabel.textColor = .white
        timerLabel.isHidden = true

        largeCustomLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        smallCustomLable.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(12)
        }
        
        timerLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-12)
        }
        
    }
    
    
    func selectTimer(mins: Int) {
        if mins == 10 || mins == 15 || mins == 20 || mins == 25 || mins == 30 {
            largeCustomLabel.isHidden = false
            smallCustomLable.isHidden = true
            timerLabel.isHidden = true
            bIsSelected = false
            self.backgroundColor = Colors.bgZ2
        } else {
            bIsSelected = true
            self.backgroundColor = Colors.bluePrimary
            largeCustomLabel.isHidden = true
            smallCustomLable.isHidden = false
            timerLabel.isHidden = false
            var timerText = ""
            var hrLen = 0
            var minLen = 0
            if mins >= 60 {
                let hourTime = mins / 60
                let minTime = mins % 60
                hrLen = hourTime > 9 ? 2 : 1
                minLen = 2
                let hourStr = String(format: "%dhr", hourTime)
                let minStr = String(format: "%02dmin", minTime)
                timerText = hourStr + minStr
            } else {
                minLen = mins > 9 ? 2 : 1
                timerText = String(format: "%dmin", mins)
            }
            let attributedText = NSMutableAttributedString(string:timerText)
            if hrLen > 0 {
                attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 12, weight: .semibold), range: NSMakeRange(hrLen, 2))
                attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 12, weight: .semibold), range: NSMakeRange(hrLen+4, 3))
            } else {
                attributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 12, weight: .semibold), range: NSMakeRange(minLen, 3))
            }
            timerLabel.attributedText = attributedText
        }
    }
    

}
