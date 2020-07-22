//
//  IntroductionView.swift
//  Flowtime
//
//  Created by Enter on 2019/12/26.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI

class IntroductionView: BaseView {
    
    public var time: Int = 0 {
        willSet {
            minLabel.text = "\(newValue) mins"
        }
    }
    
    public var date: Date? {
        willSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M.d.yyyy"
            header.titleText = dateFormatter.string(from: newValue!)
        }
    }
    
    public var index: Int = 0 {
        willSet {
            var unit = "th"
            switch newValue % 10 {
            case 1:
                unit = "st"
            case 2:
                unit = "nd"
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
            countLabel.text = "\(newValue)"+unit
        }
    }
    
    public var total: Int = 0 {
        willSet {
            timesLabel.text = "\(newValue) minutes"
        }
    }

    public let header = PrivateReportViewHead()
    private let durationLabel = UILabel()
    private let minLabel = UILabel()
    private let thisLabel = UILabel()
    private let countLabel = UILabel()
    private let meditationLabel = UILabel()
    private let thereLabel = UILabel()
    private let timesLabel = UILabel()
    private let totalLabel = UILabel()
    private let dialImage = UIImageView()
    private let clockImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    override func setup() {
        self.backgroundColor = .clear
        
        durationLabel.text = "Duration of this experience:"
        durationLabel.font = UIFont.systemFont(ofSize: 12)
        durationLabel.textColor = .white
        self.addSubview(durationLabel)
        
        minLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        minLabel.textColor = .white
        self.addSubview(minLabel)
        
        dialImage.image = #imageLiteral(resourceName: "icon_dial")
        self.addSubview(dialImage)
        
        thisLabel.font = UIFont.systemFont(ofSize: 16)
        thisLabel.textColor = .white
        thisLabel.text = "This is my "
        self.addSubview(thisLabel)
        
        countLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        countLabel.textColor = .white
        self.addSubview(countLabel)
        
        meditationLabel.text = " meditation"
        meditationLabel.font = UIFont.systemFont(ofSize: 16)
        meditationLabel.textColor = .white
        self.addSubview(meditationLabel)
        
        thereLabel.font = UIFont.systemFont(ofSize: 16)
        thereLabel.textColor = .white
        thereLabel.text = "There are "
        self.addSubview(thereLabel)
        
        totalLabel.text = " in total"
        totalLabel.font = UIFont.systemFont(ofSize: 16)
        totalLabel.textColor = .white
        self.addSubview(totalLabel)

        timesLabel.textColor = .white
        timesLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        self.addSubview(timesLabel)
        
        header.image = #imageLiteral(resourceName: "icon_over_view")
        self.addSubview(header)
        
        clockImage.image = #imageLiteral(resourceName: "icon_clock")
        self.addSubview(clockImage)
    }
    
    override func layout() {
        durationLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.top.equalTo(header.snp.bottom).offset(16)
        }
        
        minLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.top.equalTo(durationLabel.snp.bottom).offset(4)
        }
        
        dialImage.snp.makeConstraints {
            $0.top.equalTo(minLabel.snp.bottom).offset(16)
            $0.width.height.equalTo(24)
            $0.left.equalToSuperview().offset(24)
        }
        
        thisLabel.snp.makeConstraints {
            $0.left.equalTo(dialImage.snp.right).offset(8)
            $0.centerY.equalTo(dialImage.snp.centerY)
        }
        
        countLabel.snp.makeConstraints {
            $0.left.equalTo(thisLabel.snp.right)
            $0.centerY.equalTo(dialImage.snp.centerY)
        }
        meditationLabel.snp.makeConstraints {
            $0.centerY.equalTo(dialImage.snp.centerY)
            $0.left.equalTo(countLabel.snp.right)
        }
        
        clockImage.snp.makeConstraints {
            $0.top.equalTo(dialImage.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(24)
        }
        thereLabel.snp.makeConstraints {
            $0.left.equalTo(clockImage.snp.right).offset(8)
            $0.centerY.equalTo(clockImage.snp.centerY)
        }
        timesLabel.snp.makeConstraints {
            $0.left.equalTo(thereLabel.snp.right)
            $0.centerY.equalTo(clockImage.snp.centerY)
        }
        totalLabel.snp.makeConstraints {
            $0.left.equalTo(timesLabel.snp.right)
            $0.centerY.equalTo(clockImage.snp.centerY)
        }
        
    }
}
