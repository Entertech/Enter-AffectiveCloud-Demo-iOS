//
//  MeditateExit.swift
//  Flowtime
//
//  Created by Enter on 2019/8/1.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

protocol MeditationExitDelegate: class {
    func meditationExit()
    func cancelAction()
}

class MeditateExit: BaseView {
    
    enum ExitType {
        case early
        case finish
        case disconnect
    }
    
    private let tipImageView = UIImageView()
    private let titleLabel = UILabel()
    private let tipLabel = UILabel()
    private let soundLabel = UILabel()
    private let soundImage = UIButton()
    private let exitBtn = UIButton()
    private let notNowBtn = UIButton()
    public var exitType: ExitType  = .finish
    public weak var delegate: MeditationExitDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, exitType: ExitType) {
        self.exitType = exitType
        super.init(frame: frame)
        self.alpha = 0.6
    }
    
    override func setup() {
        showBlurEffectBackground()
        //图片
        self.addSubview(tipImageView)
        switch exitType {
        case .early:
            tipImageView.image = #imageLiteral(resourceName: "img_meditate_early")
        case .finish:
            tipImageView.image = #imageLiteral(resourceName: "img_meditate_finish")
        case .disconnect:
            tipImageView.image = #imageLiteral(resourceName: "img_meditate_disconnect")
        }
        
        //大标题
        self.addSubview(titleLabel)
        switch exitType {
        case .early:
            titleLabel.text = "现在结束?"
        case .finish:
            titleLabel.text = "训练结束。"
        case .disconnect:
            titleLabel.text = "糟糕!"
        }
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        
        //提示文字
        self.addSubview(tipLabel)
        switch exitType {
        case .early:
            tipLabel.text = "需要训练至少 3 分钟才能生成报告。"
        case .finish:
            tipLabel.text = "结束并获取报告."
        case .disconnect:
            let attributedText = NSMutableAttributedString(string: "连接头环以显示数据。")
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            style.lineSpacing = 5
            style.lineBreakMode = .byWordWrapping
            attributedText.addAttribute(kCTParagraphStyleAttributeName as NSAttributedString.Key, value: style, range: NSMakeRange(0, attributedText.length))
            tipLabel.attributedText = attributedText
            
        }
        tipLabel.textAlignment = .center
        tipLabel.textColor = .white
        tipLabel.lineBreakMode = .byWordWrapping
        tipLabel.numberOfLines = 0
        tipLabel.font = UIFont.systemFont(ofSize: 16)
        
        
        //断开声音提示
        self.addSubview(soundLabel)
        if exitType == .disconnect {
            let attributedText = NSMutableAttributedString(string: "当蓝牙或网络断开，你可以听到提示音。")
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            style.lineSpacing = 5
            style.lineBreakMode = .byWordWrapping
            attributedText.addAttribute(kCTParagraphStyleAttributeName as NSAttributedString.Key, value: style, range: NSMakeRange(0, attributedText.length))
            soundLabel.attributedText = attributedText
            soundLabel.textAlignment = .center
            soundLabel.textColor = UIColor(white: 1.0, alpha: 0.8)
            soundLabel.font = UIFont.systemFont(ofSize: 14)
            soundLabel.numberOfLines = 0
            soundLabel.lineBreakMode = .byWordWrapping
        }
        
        
        //声音图标
        if exitType == .disconnect {
            self.addSubview(soundImage)
            soundImage.setImage(#imageLiteral(resourceName: "icon_trumpet"), for: UIControl.State.normal)
            soundImage.addTarget(self, action: #selector(dismissSound(_:)), for: .touchUpInside)
        }
        
        //退出按钮
        self.addSubview(exitBtn)
        switch exitType {
        case .early:
            exitBtn.setTitle("取消", for: .normal)
        case .finish:
            exitBtn.setTitle("结束并获取报告", for: .normal)
        case .disconnect:
            exitBtn.setTitle("结束", for: .normal)
        }
        exitBtn.setTitleColor(.white, for: .normal)
        exitBtn.setTitleColor(.gray, for: .highlighted)
        exitBtn.setBackgroundImage(#imageLiteral(resourceName: "img_btn_corner"), for: .normal)
        exitBtn.addTarget(self, action: #selector(exitView(_:)), for: .touchUpInside)
        
        
        //取消按钮
        self.addSubview(notNowBtn)
        switch exitType {
        case .early:
            notNowBtn.setTitle("结束", for: .normal)
        case .finish:
            notNowBtn.setTitle("取消", for: .normal)
        case .disconnect:
            notNowBtn.setTitle("取消", for: .normal)
        }
        notNowBtn.setTitleColor(.white, for: .normal)
        notNowBtn.setTitleColor(.gray, for: .highlighted)
        notNowBtn.backgroundColor = .clear
        notNowBtn.addTarget(self, action: #selector(dismissView(_:)), for: .touchUpInside)
    }
    
    override func layout() {
        var multiplyPercent = 0.6
        switch exitType {
        case .early:
            tipImageView.snp.makeConstraints{
                $0.width.equalTo(288)
                $0.height.equalTo(214)
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview().multipliedBy(multiplyPercent)
            }
        case .finish:
            tipImageView.snp.makeConstraints{
                $0.width.equalTo(257)
                $0.height.equalTo(198)
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview().multipliedBy(multiplyPercent)
            }
        case .disconnect:
            multiplyPercent = 0.4
            tipImageView.snp.makeConstraints{
                $0.width.equalTo(120)
                $0.height.equalTo(120)
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview().multipliedBy(multiplyPercent)
            }
        }
        
        //大标题
        
        var offsetY = 24.0
        switch exitType {
        case .early:
            break
        case .finish:
            break
        case .disconnect:
            offsetY = 16
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(tipImageView.snp.bottom).offset(offsetY)
            $0.centerX.equalToSuperview()
        }
        
        //提示文字
        var tipLabelHeight = 24
        switch exitType {
        case .early:
            break
        case .finish:
            break
        case .disconnect:
            tipLabelHeight = 72
            
        }
        tipLabel.snp.makeConstraints{
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.height.equalTo(tipLabelHeight)
        }
        
        //断开声音提示
        var soundLabelHeight = 0
        var soundLabelTopOffset = 0
        if exitType == .disconnect {
            soundLabelHeight = 42
            soundLabelTopOffset = 24
        }
        soundLabel.snp.makeConstraints{
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-24)
            $0.top.equalTo(tipLabel.snp.bottom).offset(soundLabelTopOffset)
            $0.height.equalTo(soundLabelHeight)
        }
        
        
        //声音图标
        if exitType == .disconnect {
            soundImage.snp.makeConstraints{
                $0.width.height.equalTo(48)
                $0.centerX.equalToSuperview()
                $0.top.equalTo(soundLabel.snp.bottom).offset(8)
            }
        }
        
        //退出按钮
        exitBtn.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.width.equalTo(345)
            $0.height.equalTo(47)
            $0.top.equalTo(soundLabel.snp.bottom).offset(88)
        }
        
        //取消按钮
        notNowBtn.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.width.equalTo(345)
            $0.height.equalTo(47)
            $0.top.equalTo(exitBtn.snp.bottom).offset(8)
        }
    }
    
    
    ///毛玻璃背景
    private func showBlurEffectBackground() {
        self.backgroundColor = .clear
        //模糊效果
        let blurEffect = UIBlurEffect(style: .dark)
        //创建一个承载模糊效果的视图
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.frame
        self.addSubview(blurView)
        //创建并添加vibrancy视图
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect:vibrancyEffect)
        
        vibrancyView.frame = self.bounds
        blurView.contentView.addSubview(vibrancyView)
    }
    
    public func showView() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = 1
        }) { (isSuccess) in
            return
        }
    }

    ///让view消失
    @objc func dismissView(_ sender: UIButton) {
        
        switch exitType {
        case .early:
            self.delegate?.meditationExit()
        case .finish:
            self.alpha = 0.6
            self.removeFromSuperview()
            self.delegate?.cancelAction()
        case .disconnect:
            self.alpha = 0.6
            self.removeFromSuperview()
            self.delegate?.cancelAction()
            
        }
        
    }
    
    
    @objc func exitView(_ sender: UIButton) {
        switch exitType {
        case .early:
            self.alpha = 0.6
            self.removeFromSuperview()
            self.delegate?.cancelAction()
        case .finish:

            self.delegate?.meditationExit()
        case .disconnect:
            self.delegate?.meditationExit()
            
        }
        
    }
    
    @objc func dismissSound(_ sender: UIButton) {
        guard let path = Bundle.main.path(forResource: "error_tip", ofType: "mp3") else { return }
        if let url = URL(string: path) {
            let player = SoundPlayer(url, soundID: 1)
            player.play()
        }
    }
}
