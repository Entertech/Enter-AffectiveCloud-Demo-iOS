//
//  WearStateView.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/1/13.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit

public class CheckWearStateView: UIView {
    public var isNeedExpand = true //是否需要收起来
    private var _wearValue: UInt8 = 255
    public var wearValue: UInt8 = 0 {
        willSet {
            if _wearValue == newValue {
                return
            }
            _wearValue = newValue
            if newValue == .zero {
                state = .wear
                
                firstView.backgroundColor = wearColor
                secondView.backgroundColor = wearColor
                thirdView.backgroundColor = wearColor
                fifthView.backgroundColor = wearColor
            } else {

                if newValue == 15 {
                    forthView.backgroundColor = notColor
                } else {
                    forthView.backgroundColor = wearColor
                }
                firstView.backgroundColor = newValue >> 3 & 1 == 1 ? notColor : wearColor
                secondView.backgroundColor = newValue >> 2 & 1 == 1 ? notColor : wearColor
                thirdView.backgroundColor = newValue >> 1 & 1 == 1 ? notColor : wearColor
                fifthView.backgroundColor = newValue & 1 == 1 ? notColor : wearColor
                state = .not
            }
        }

    }
    
    public enum WearState {
        case wear
        case not
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        setUI()
    }
    
    var state = WearState.not {
        willSet {
            guard isNeedExpand else {
                return
            }
            switch newValue {
            case .wear:
                setViewExpend(false)
                showBtn.isHidden = false
                showBtn.setImage(#imageLiteral(resourceName: "icon_down"), for: .normal)
                forthView.backgroundColor = wearColor
            case .not:
                setViewExpend(true)
                showBtn.isHidden = true
                showBtn.setImage(#imageLiteral(resourceName: "icon_up"), for: .normal)
            }
        }
    }
    let wearColor = UIColor.colorWithHexString(hexColor: "#7AFFC0")
    let notColor = UIColor.colorWithHexString(hexColor: "#FF6682")
    var isForceToShow = false
    
    let titleImage = UIImageView()
    let titleLabel = UILabel()
    let normalLabel = UILabel()
    let showBtn = UIButton()
    let tipLabel = UILabel()
    let firstView = UIView()
    let secondView = UIView()
    let thirdView = UIView()
    let forthView = UIView()
    let fifthView = UIView()
    let blackView = UIView()
    public let leftLabel = UILabel()
    public let rightLabel = UILabel()
    
    private func setUI() {
        self.backgroundColor = UIColor.colorWithHexString(hexColor: "#343854")
        self.layer.cornerRadius = 16
        self.addSubview(titleImage)
        self.addSubview(titleLabel)
        self.addSubview(normalLabel)
        self.addSubview(showBtn)
        self.addSubview(tipLabel)
        blackView.addSubview(firstView)
        blackView.addSubview(secondView)
        blackView.addSubview(thirdView)
        blackView.addSubview(forthView)
        blackView.addSubview(fifthView)
        self.addSubview(blackView)
        blackView.addSubview(leftLabel)
        blackView.addSubview(rightLabel)
        
        titleImage.image = #imageLiteral(resourceName: "icon_inspection")
        titleImage.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.top.equalTo(11)
            $0.height.width.equalTo(24)
        }
        
        titleLabel.text = "佩戴状态"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(titleImage.snp.right).offset(20)
            $0.centerY.equalTo(titleImage.snp.centerY)
        }
        
        normalLabel.text = "连接正常"
        normalLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        normalLabel.textColor = UIColor.colorWithHexString(hexColor: "#7AFFC0")
        normalLabel.isHidden = true
        normalLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(titleImage.snp.centerY)
        }
        
        showBtn.setImage(#imageLiteral(resourceName: "icon_down"), for: .normal)
        showBtn.addTarget(self, action: #selector(showAction), for: .touchUpInside)
        showBtn.isHidden = true
        showBtn.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.right.equalTo(-16)
            $0.top.equalTo(11)
        }
        
        tipLabel.numberOfLines = 0
        tipLabel.lineBreakMode = .byWordWrapping
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textColor = UIColor(white: 1, alpha: 0.8)
        let attributedText = NSMutableAttributedString(string:"佩戴头环，根据提示调整电极接触。提示点对应头环上最左、中间和最右的电极点。")
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineSpacing = 5
        attributedText.addAttribute(
            kCTParagraphStyleAttributeName as NSAttributedString.Key,
            value: style,
            range: NSMakeRange(0, attributedText.length))
        tipLabel.attributedText = attributedText
        tipLabel.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.right.equalTo(-16)
            $0.top.equalTo(titleImage.snp.bottom).offset(4)
            $0.bottom.equalTo(blackView.snp.top).offset(-4)
        }
        
        blackView.layer.cornerRadius = 16
        blackView.backgroundColor = UIColor.colorWithHexString(hexColor: "#151935")
        blackView.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.right.equalTo(-16)
            $0.height.equalTo(45)
            $0.bottom.equalToSuperview().offset(-12)
        }

        leftLabel.text = "左边"
        leftLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        leftLabel.textColor = UIColor(white: 1, alpha: 0.3)
        leftLabel.snp.makeConstraints {
            $0.left.equalTo(8)
            $0.centerY.equalToSuperview()
        }

        rightLabel.text = "右边"
        rightLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        rightLabel.textColor = UIColor(white: 1, alpha: 0.3)
        rightLabel.snp.makeConstraints {
            $0.right.equalTo(-8)
            $0.centerY.equalToSuperview()
        }
        
        firstView.layer.cornerRadius = 2
        firstView.backgroundColor = notColor
        firstView.snp.makeConstraints {
            $0.right.equalTo(secondView.snp.left).offset(-44)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(20)
            $0.height.equalTo(12)
        }
        secondView.layer.cornerRadius = 2
        secondView.backgroundColor = notColor
        secondView.snp.makeConstraints {
            $0.width.height.equalTo(12)
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-8)
        }
        thirdView.layer.cornerRadius = 2
        thirdView.backgroundColor = notColor
        thirdView.snp.makeConstraints {
            $0.width.height.equalTo(12)
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(8)
        }
        forthView.layer.cornerRadius = 2
        forthView.backgroundColor = notColor
        forthView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(20)
            $0.height.equalTo(12)
            $0.left.equalTo(thirdView.snp.right).offset(12)
        }
        fifthView.layer.cornerRadius = 2
        fifthView.backgroundColor = notColor
        fifthView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(20)
            $0.height.equalTo(12)
            $0.left.equalTo(forthView.snp.right).offset(12)
        }
    }
    
    public override func didMoveToSuperview() {
        superview?.didMoveToSuperview()
//        self.snp.makeConstraints {
//            $0.height.equalTo(151)
//        }
    }
    
    
    private func setViewExpend(_ isNeed: Bool) {

        if isNeed {

            self.snp.updateConstraints {
                $0.height.equalTo(151)
            }
            self.backgroundColor = UIColor.colorWithHexString(hexColor: "#343854")

            blackView.isHidden = false
        } else {

            self.snp.updateConstraints {
                $0.height.equalTo(46)
            }
            self.backgroundColor = .white

            blackView.isHidden = true

        }

    }
    
    @objc func showAction(_ sender: UIButton) {
        if self.bounds.height < 50 {
            setViewExpend(true)
            sender.setImage(#imageLiteral(resourceName: "icon_up"), for: .normal)
        } else {
            setViewExpend(false)
            sender.setImage(#imageLiteral(resourceName: "icon_down"), for: .normal)
        }
    }
    
}
