//
//  TimerSelectView.swift
//  Flowtime
//
//  Created by Enter on 2020/6/11.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit

class TimerSelectView: UIControl {

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
    
    @IBInspectable
    var timer: Int = 10 {
        didSet {
            numberText.text = "\(timer)"
        }
    }
    
    private var numberText = UILabel()
    private var minText = UILabel()
    var bIsSelected = false
    
    func setUI() {
        self.backgroundColor = Colors.bgZ2
        numberText.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        numberText.text = "\(timer)"
        numberText.textAlignment = .center
        numberText.textColor = Colors.textLv1
        
        minText.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        minText.text = "分钟"
        minText.textAlignment = .center
        minText.textColor = Colors.textLv1
        self.addSubview(numberText)
        self.addSubview(minText)
        
        numberText.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-12)
        }
        
        minText.snp.makeConstraints {
            $0.bottom.equalTo(numberText.snp.bottom).offset(-4)
            $0.left.equalTo(numberText.snp.right)
        }
    }
    
    func selectTimer(isSelected: Bool) {
        if isSelected {
            self.backgroundColor = Colors.bluePrimary
            minText.textColor = .white
            numberText.textColor = .white
            bIsSelected = true
            //self.isEnabled = false
        } else {
            self.backgroundColor = Colors.bgZ2
            minText.textColor = Colors.textLv1
            numberText.textColor = Colors.textLv1
            bIsSelected = false
            //self.isEnabled = true
        }
    }
    
}
