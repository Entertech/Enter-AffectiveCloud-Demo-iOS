//
//  StatisticsReport.swift
//  Flowtime
//
//  Created by Enter on 2019/12/31.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class StatisticsReport: BaseView {
    public var number: Int = 0{
        willSet {
            var unit = "th"
            switch newValue % 10 {
            case 1:
                unit = "st"
            case 2:
                if newValue == 12 {
                    unit = "th"
                } else {
                    unit = "nd"
                }
            case 3:
                unit = "rd"
            default:
                unit = "th"
            }
            switch newValue % 100 {
            case 11:
                unit = "th"
            case 12:
                unit = "th"
            case 13:
                unit = "th"
            default:
                break
            }
            
            let intLen = countNumLen(newValue: newValue)
            let attributedText = NSMutableAttributedString(string:"🎊🎉 This is my \(newValue)\(unit) meditation")
            attributedText.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17, weight: .bold)], range: NSMakeRange(16, intLen+2))
            thisLabel.attributedText = attributedText
        }
    }
    
    public var count: Int = 0{
        willSet {
            let iLen = countNumLen(newValue: newValue)
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            style.lineSpacing = 5
            let attributedText = NSMutableAttributedString(string:"✌️And I have meditated for \(newValue) minutes \nfrom the beginning!👏👏")
            attributedText.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17, weight: .bold)], range: NSMakeRange(27, iLen+8))
            attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: style], range: NSMakeRange(0, attributedText.length))
            andLabel.attributedText = attributedText
        }
    }
    
    private let thisLabel = UILabel()
    private let andLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let _ = self.superview else { return }
        self.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(105)
        }
    }

    override func setup() {
        self.cornerRadius = 8
        self.addSubview(thisLabel)
        self.addSubview(andLabel)
        thisLabel.font = UIFont.systemFont(ofSize: 16)
        thisLabel.textAlignment = .center
        
        andLabel.font = UIFont.systemFont(ofSize: 16)
        andLabel.textAlignment = .center
        andLabel.numberOfLines = 0
        andLabel.lineBreakMode = .byWordWrapping
    }
    
    override func layout() {
        thisLabel.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.right.equalTo(-16)
            $0.top.equalToSuperview().offset(10)
            $0.height.equalTo(21)
        }
        
        andLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalTo(thisLabel.snp.bottom).offset(4)
        }
    }
    
    func countNumLen(newValue: Int) -> Int {
        var intLen = 1
        if newValue / 1000 > 0 {
            intLen = 4
        } else if newValue / 100 > 0 {
            intLen = 3
        } else if newValue / 10 > 0 {
            intLen = 2
        } else {
            intLen = 1
        }
        return intLen
    }
    
}
