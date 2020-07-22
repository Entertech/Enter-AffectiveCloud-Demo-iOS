//
//  HowToConnectGuideView.swift
//  Flowtime
//
//  Created by Enter on 2020/6/12.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit

class HowToConnectGuideView: UIView {
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
    
    //let sensorCheckView = SensorCheckView()
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
        title.text = "如何连接设备"
        title.textColor = Colors.textLv1
        title.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        self.addSubview(title)
        title.snp.makeConstraints {
            $0.left.equalTo(icon.snp.right).offset(16)
            $0.centerY.equalTo(icon.snp.centerY)
        }
        
        let indicator = UIImageView()
        indicator.image = #imageLiteral(resourceName: "icon_arrow_blue")
        self.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-24)
            $0.centerY.equalTo(icon.snp.centerY)
        }
        
        let guideLabel = UILabel()
        self.addSubview(guideLabel)
        let attributedText = NSMutableAttributedString(string:"按照指南连接设备。如果仍然无法连接头带，请查看指南末尾的故障排除链接。")
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineSpacing = 5
        attributedText.addAttribute(
            kCTParagraphStyleAttributeName as NSAttributedString.Key,
            value: style,
            range: NSMakeRange(0, attributedText.length))
        guideLabel.attributedText = attributedText
        guideLabel.numberOfLines = 0
        guideLabel.lineBreakMode = .byWordWrapping
        guideLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(44)
            $0.bottom.equalToSuperview().offset(-16)
        }
        //
        //        self.addSubview(sensorCheckView)
        //        sensorCheckView.snp.makeConstraints {
        //            $0.left.equalToSuperview().offset(16)
        //            $0.right.equalToSuperview().offset(-16)
        //            $0.top.equalTo(guideLabel.snp.bottom).offset(6)
        //            $0.height.equalTo(45)
        //        }
        //        sensorCheckView.layer.cornerRadius = 16
        
        self.addSubview(moreInfoBtn)
        moreInfoBtn.setTitle("", for: .normal)
        moreInfoBtn.backgroundColor = .clear
        moreInfoBtn.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }


}
