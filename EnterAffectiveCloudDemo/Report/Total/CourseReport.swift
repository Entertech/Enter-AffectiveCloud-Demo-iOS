//
//  CourseReport.swift
//  Flowtime
//
//  Created by Enter on 2019/12/31.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class CourseReport: BaseView {
    
    /// course, collection
    public var course: (String, String) = ("", "") {
        willSet {
            courseLabel.text = newValue.0

        }
    
    }
    
    private let theLabel = UILabel()
    private let courseLabel = UILabel()
    private let fromLabel = UILabel()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let _ = self.superview else { return }
        self.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(102)
        }
    }
    
    override func setup() {
        self.layer.cornerRadius = 8
        self.addSubview(theLabel)
        self.addSubview(courseLabel)
        self.addSubview(fromLabel)
        theLabel.text = "The course I learned is:"
        theLabel.textColor = UIColor.colorWithHexString(hexColor: "999999")
        theLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        theLabel.textAlignment = .center
        
        courseLabel.text = "Mindful Pregnancy"
        courseLabel.textColor = UIColor.colorWithHexString(hexColor: "4b5dcc")
        courseLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        courseLabel.textAlignment = .center
        
        fromLabel.isHidden = true
        fromLabel.text = "from Painful Sensations"
        fromLabel.textColor = UIColor.colorWithHexString(hexColor: "999999")
        fromLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        fromLabel.textAlignment = .center
    }
    
    override func layout() {
        theLabel.snp.makeConstraints {
            $0.top.equalTo(16)
            $0.left.equalTo(24)
            $0.right.equalTo(-24)
            $0.height.equalTo(21)
        }
        courseLabel.snp.makeConstraints {
            $0.top.equalTo(theLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalTo(-24)
            $0.height.equalTo(24)
        }
    }

}
