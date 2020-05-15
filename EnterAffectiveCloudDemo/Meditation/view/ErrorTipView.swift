//
//  ErrorTipView.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/14.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import SnapKit

class ErrorTipView: UIView {
    let fixBtn = UIButton(type: .system)
    let titleLabel = UILabel()
    let tipLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    func setUI() {
        self.backgroundColor = #colorLiteral(red: 1, green: 0.9058823529, blue: 0.9019607843, alpha: 1)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        let titleImage = UIImageView(image: UIImage.init(named: "icon_error"))
        self.addSubview(titleImage)
        
        
        titleLabel.textColor = #colorLiteral(red: 1, green: 0.4, blue: 0.5098039216, alpha: 1)
        titleLabel.text = "网络连接错误"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        self.addSubview(titleLabel)
        
        let attributedText = NSMutableAttributedString(string:"网络连接中断，数据分析已停止。请检查网络连接，然后尝试恢复分析。")
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineSpacing = 5
        attributedText.addAttribute(
            kCTParagraphStyleAttributeName as NSAttributedString.Key,
            value: style,
            range: NSMakeRange(0, attributedText.length))
        
        tipLabel.attributedText = attributedText
        tipLabel.lineBreakMode =  .byWordWrapping
        tipLabel.numberOfLines = 2
        tipLabel.textColor = #colorLiteral(red: 0.4980392157, green: 0.3490196078, blue: 0.3764705882, alpha: 1)
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(tipLabel)
        
        fixBtn.setTitle("恢复", for: .normal)
        fixBtn.setTitleColor(#colorLiteral(red: 0.2941176471, green: 0.3647058824, blue: 0.8, alpha: 1), for: .normal)
        fixBtn.backgroundColor = .clear
        fixBtn.layer.borderWidth = 1
        fixBtn.layer.borderColor = #colorLiteral(red: 0.2941176471, green: 0.3647058824, blue: 0.8, alpha: 1)
        fixBtn.layer.cornerRadius = 16
        fixBtn.layer.masksToBounds = true
        self.addSubview(fixBtn)
        
        titleImage.snp.makeConstraints {
            $0.height.width.equalTo(24)
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview().offset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(titleImage.snp.right).offset(10)
            $0.top.equalToSuperview().offset(16)
        }
        
        tipLabel.snp.makeConstraints {
            $0.top.equalTo(titleImage.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(45)
        }
        
        fixBtn.snp.makeConstraints {
            $0.top.equalTo(tipLabel.snp.bottom).offset(24)
            $0.height.equalTo(32)
            $0.width.equalTo(200)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    /// 切换提示
    /// - Parameter value: 0:Net 1:BLE
    func changeTipText(value: ErrorType) {
        switch value {
        case .network:
            titleLabel.text = "网络连接错误"
            let attributedText = NSMutableAttributedString(string:"网络连接中断，数据分析已停止。请检查网络连接，然后尝试恢复分析。")
            let style = NSMutableParagraphStyle()
            style.alignment = .left
            style.lineSpacing = 5
            attributedText.addAttribute(
                kCTParagraphStyleAttributeName as NSAttributedString.Key,
                value: style,
                range: NSMakeRange(0, attributedText.length))
            
            tipLabel.attributedText = attributedText
        case .bluetooth:
            titleLabel.text = "蓝牙连接断开"
            let attributedText = NSMutableAttributedString(string:"蓝牙连接断开, 请靠近设备后点击重新连接")
            let style = NSMutableParagraphStyle()
            style.alignment = .left
            style.lineSpacing = 5
            attributedText.addAttribute(
                kCTParagraphStyleAttributeName as NSAttributedString.Key,
                value: style,
                range: NSMakeRange(0, attributedText.length))
            
            tipLabel.attributedText = attributedText
        case .poor:
            titleLabel.text = "信号质量差"
            let attributedText = NSMutableAttributedString(string:"您可能没有佩戴好设备，请点击按钮根据指引正确佩戴")
            let style = NSMutableParagraphStyle()
            style.alignment = .left
            style.lineSpacing = 5
            attributedText.addAttribute(
                kCTParagraphStyleAttributeName as NSAttributedString.Key,
                value: style,
                range: NSMakeRange(0, attributedText.length))
            
            tipLabel.attributedText = attributedText
        default:
            break
        }
    }
    

}
