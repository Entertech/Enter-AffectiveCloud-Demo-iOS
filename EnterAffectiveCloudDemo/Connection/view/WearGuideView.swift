//
//  wearGuide.swift
//  Flowtime
//
//  Created by Enter on 2020/4/9.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit

class WearGuideView: UIView {

    init() {
        super.init(frame: CGRect.zero)
        setUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    let moreInfoBtn = UIButton()
    
    private func setUI() {
        self.backgroundColor = Colors.bgZ1
        
        let icon = UIImageView()
        icon.image = #imageLiteral(resourceName: "icon_inspection")
        self.addSubview(icon)
        icon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.left.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
        }
        
        let title = UILabel()
        title.text = "Wearing Guide"
        title.textColor = Colors.textLv1
        title.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        self.addSubview(title)
        title.snp.makeConstraints {
            $0.left.equalTo(icon.snp.right).offset(16)
            $0.centerY.equalTo(icon.snp.centerY)
        }
        
        let indicator = UIImageView()
        indicator.image = #imageLiteral(resourceName: "icon_blue_indicator")
        self.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-24)
            $0.centerY.equalTo(icon.snp.centerY)
        }
        
        let guideLabel = UILabel()
        self.addSubview(guideLabel)
        let attributedText = NSMutableAttributedString(string:"传感器必须与皮肤完全接触。 遵循佩戴指南以获取良好信号。")
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineSpacing = 5
        attributedText.addAttribute(
            kCTParagraphStyleAttributeName as NSAttributedString.Key,
            value: style,
            range: NSMakeRange(0, attributedText.length))
        guideLabel.attributedText = attributedText
        guideLabel.numberOfLines = 2
        guideLabel.lineBreakMode = .byWordWrapping
        guideLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(44)
        }
        
        self.addSubview(moreInfoBtn)
        moreInfoBtn.setTitle("", for: .normal)
        moreInfoBtn.backgroundColor = .clear
        moreInfoBtn.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }

}
