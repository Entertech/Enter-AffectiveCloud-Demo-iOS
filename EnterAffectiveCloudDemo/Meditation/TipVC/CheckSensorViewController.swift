//
//  CheckSensorViewController.swift
//  Flowtime
//
//  Created by Enter on 2020/6/10.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import Lottie

protocol CheckSensorTipDelegate: class {
    func dismissVC()
}

class CheckSensorTipViewController: UIViewController, CheckWearDelegate {

    let leftView = UIView()
    let rightView = UIView()
    weak var delegate: CheckSensorTipDelegate?
    let rightTitle = UILabel()
    let rightDoneView = AnimationView()
    let rightDoneText = UILabel()
    let rightOkBtn = UIButton()
    let rightCancelBtn = UIButton()
    let rightSkipView = AnimationView()
    let waitAnimationView = AnimationView(name: "checking")
    let rightSkipText = UILabel()
    var isLeftViewShowed = false
    let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
    let viewDot = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(white: 0, alpha: 0)
        setLeftView()
        setRightView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    private func setLeftView() {
        leftView.backgroundColor = Colors.bg1
        leftView.layer.cornerRadius = 20
        leftView.layer.masksToBounds = true
        self.view.addSubview(leftView)
        leftView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(8)
            $0.width.equalToSuperview().offset(-16)
            $0.height.equalTo(384)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(450)
        }
        
        let leftCloseBtn = UIButton()
        leftCloseBtn.setImage(#imageLiteral(resourceName: "icon_close_round"), for: .normal)
        leftView.addSubview(leftCloseBtn)
        leftCloseBtn.addTarget(self, action: #selector(closeLeft), for: .touchUpInside)
        leftCloseBtn.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.right.equalTo(-8)
            $0.top.equalTo(8)
        }
        
        let leftTitle = UILabel()
        leftTitle.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        leftTitle.text = "佩戴检测"
        leftTitle.textAlignment = .center
        leftTitle.textColor = Colors.textLv1
        leftView.addSubview(leftTitle)
        leftTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(24)
        }
        
        let leftTipView = UIView()
        leftView.addSubview(leftTipView)
        leftTipView.backgroundColor = Colors.red4
        leftTipView.layer.cornerRadius = 16
        leftTipView.layer.masksToBounds = true
        leftTipView.snp.makeConstraints {
            $0.top.equalTo(leftTitle.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(137)
        }
        
        let tipImageView = UIImageView()
        tipImageView.layer.cornerRadius = 20
        tipImageView.image = #imageLiteral(resourceName: "img_check_demo")
        leftTipView.addSubview(tipImageView)
        tipImageView.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalTo(106)
        }
        
        let tipLabel = UILabel()
        leftTipView.addSubview(tipLabel)
        let attributedText = NSMutableAttributedString(string:"佩戴头戴并根据引导调整传感器。")
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineSpacing = 5
        attributedText.addAttribute(
            kCTParagraphStyleAttributeName as NSAttributedString.Key,
            value: style,
            range: NSMakeRange(0, attributedText.length))
        tipLabel.numberOfLines = 0
        tipLabel.lineBreakMode = .byWordWrapping
        tipLabel.attributedText = attributedText
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textColor = .white
        tipLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.left.equalTo(tipImageView.snp.right).offset(16)
            $0.top.equalToSuperview().offset(16)
        }
        
        
        self.leftView.addSubview(waitAnimationView)
        waitAnimationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(leftTipView.snp.bottom).offset(4)
            $0.width.equalTo(150)
            $0.height.equalTo(60)
        }
        waitAnimationView.animationSpeed = 1
        waitAnimationView.loopMode = .loop
        
        let checkingLabel = UILabel()
        leftView.addSubview(checkingLabel)
        checkingLabel.textColor = Colors.red4
        checkingLabel.text = "检测中..."
        checkingLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        checkingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-82)
        }
        
        let guideBtn = UIButton()
        guideBtn.cornerRadius = 16
        guideBtn.backgroundColor = Colors.bgZ2
        guideBtn.setTitle("如何取得好的信号质量?", for: .normal)
        guideBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        guideBtn.contentHorizontalAlignment = .left
        guideBtn.titleLabel?.textAlignment = .left
        guideBtn.setTitleColor(Colors.bluePrimary, for: .normal)
        guideBtn.setTitleColor(Colors.btnDisable, for: .highlighted)
        guideBtn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 0)
        leftView.addSubview(guideBtn)
        guideBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-24)
            $0.height.equalTo(40)
            $0.right.equalToSuperview().offset(-16)
        }
        guideBtn.addTarget(self, action: #selector(showGuide), for: .touchUpInside)
        
        let arrowBtn = UIButton()
        guideBtn.addSubview(arrowBtn)
        arrowBtn.setImage(#imageLiteral(resourceName: "icon_arrow_blue"), for: .normal)
        arrowBtn.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.right.equalTo(guideBtn.snp.right).offset(-16)
            $0.centerY.equalTo(guideBtn.snp.centerY)
        }
        arrowBtn.addTarget(self, action: #selector(showGuide), for: .touchUpInside)
        
        viewDot.layer.cornerRadius = 8
        viewDot.backgroundColor = UIColor.colorWithHexString(hexColor: "7AFFC0").changeAlpha(to: 0.5)
        leftTipView.addSubview(viewDot)
        viewDot.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.top.equalTo(35)
            $0.left.equalTo(80)
        }
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 2
        scaleAnimation.repeatCount = 99999
        scaleAnimation.duration = 1
        scaleAnimation.autoreverses = true
        scaleAnimation.timingFunction = .init(name: .easeIn)
        viewDot.layer.add(scaleAnimation, forKey: "com.flowtime.scale")
        
    }
    
    func setRightView() {
        rightView.backgroundColor = Colors.bg1
        rightView.layer.cornerRadius = 20
        rightView.layer.masksToBounds = true
        self.view.addSubview(rightView)
        rightView.snp.makeConstraints {
            $0.width.equalTo(leftView)
            $0.height.equalTo(384)
            $0.left.equalTo(self.leftView.snp.right).offset(24)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
        }
        
        rightView.addSubview(rightTitle)
        rightView.addSubview(rightDoneView)
        rightView.addSubview(rightDoneText)
        rightView.addSubview(rightOkBtn)
        rightView.addSubview(rightCancelBtn)
        rightView.addSubview(rightSkipText)
        rightView.addSubview(rightSkipView)
        
        rightTitle.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        //rightTitle.text = "Sensor Contact Check"
        rightTitle.textAlignment = .center
        rightTitle.textColor = Colors.textLv1
        rightTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(24)
        }
        
        rightDoneText.text = "所有传感器已经接触!"
        rightDoneText.textColor = UIColor.colorWithHexString(hexColor: "#5FC695")
        rightDoneText.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        rightDoneText.textAlignment = .center
        rightDoneText.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        rightDoneView.animation = Animation.named("welldone")
        rightDoneView.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.rightDoneText.snp.top).offset(-8)
        }
        rightDoneView.animationSpeed = 1
        rightDoneView.loopMode = .playOnce
        
        rightOkBtn.cornerRadius = 22.5
        rightOkBtn.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-72)
        }
        rightOkBtn.backgroundColor = UIColor.colorWithHexString(hexColor: "#4b5dcc")
        rightOkBtn.setTitleColor(.white, for: .normal)
        rightOkBtn.setTitleColor(Colors.btnDisable, for: .highlighted)
        rightOkBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        rightOkBtn.addTarget(self, action: #selector(doneBtnAction(_:)), for: .touchUpInside)
        
        rightCancelBtn.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalTo(rightOkBtn.snp.bottom)
        }
        rightCancelBtn.setTitle("好的", for: .normal)
        rightCancelBtn.setTitleColor(Colors.btn1, for: .normal)
        rightCancelBtn.setTitleColor(Colors.btnDisable, for: .highlighted)
        rightCancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        rightCancelBtn.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
        
        rightSkipView.animation = Animation.named("nosignal")
        rightSkipView.snp.makeConstraints {
            $0.width.height.equalTo(72)
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }
        rightSkipView.animationSpeed = 1
        rightSkipView.loopMode = .loop
        
        rightSkipText.snp.makeConstraints {
            $0.left.equalToSuperview().offset(64)
            $0.right.equalToSuperview().offset(-64)
            $0.top.equalTo(self.rightSkipView.snp.bottom).offset(8)
        }
        let attributedText = NSMutableAttributedString(string:"跳过检测可能会导致信号不好。")
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.lineSpacing = 5
        attributedText.addAttribute(
            kCTParagraphStyleAttributeName as NSAttributedString.Key,
            value: style,
            range: NSMakeRange(0, attributedText.length))
        rightSkipText.attributedText = attributedText
        rightSkipText.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        rightSkipText.textColor = Colors.red2
        rightSkipText.numberOfLines = 0
        rightSkipText.lineBreakMode = .byWordWrapping
    }
    
    func doneOrSkip(isDone: Bool) {
        if isDone {
            rightTitle.text = "佩戴检测"
            rightDoneView.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.4) {
                self.rightDoneView.play()
            }
            rightDoneText.isHidden = false
            rightOkBtn.setTitle("开始使用吧!", for: .normal)
            rightOkBtn.tag = 7001
            rightCancelBtn.isHidden = true
            rightSkipView.isHidden = true
            rightSkipView.pause()
            rightSkipText.isHidden = true
        } else {
            rightTitle.text = "跳过"
            rightDoneView.isHidden = true
            rightDoneText.isHidden = true
            rightOkBtn.setTitle("取消", for: .normal)
            rightOkBtn.tag = 7000
            rightCancelBtn.isHidden = false
            rightSkipView.play()
            rightSkipView.isHidden = false
            rightSkipText.isHidden = false
        }
    }
    
    func showTip() {
        isLeftViewShowed = true
        waitAnimationView.play()
        RelaxManager.shared.setupBLE()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
            self.leftView.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-16)
            }
            self.view.layoutIfNeeded()
        }) { (flag) in
            if flag {
                
            }
        }
    }
    
    func transToRightTip() {
        isLeftViewShowed = false
        waitAnimationView.pause()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.leftView.snp.updateConstraints {
                $0.left.equalToSuperview().offset(-self.view.bounds.width)
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func transToLeftTip() {
        isLeftViewShowed = true
        waitAnimationView.play()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.leftView.snp.updateConstraints {
                $0.left.equalToSuperview().offset(8)
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func dismissTip() {
        waitAnimationView.pause()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.backgroundColor = UIColor.init(white: 0, alpha: 0)
            self.rightView.snp.updateConstraints {
                
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(450)
            }
            self.view.layoutIfNeeded()
        }) { (flag) in
            if flag {
                self.view.removeFromSuperview()
                RelaxManager.shared.clearBLE()
                self.delegate?.dismissVC()
            }
        }
    }
    
    @objc
    private func closeLeft() {
        doneOrSkip(isDone: false)
        transToRightTip()
    }
    
    @objc
    private func doneBtnAction(_ sender: UIButton) {
        if sender.tag == 7001 {
            dismissTip()
        } else {
            transToLeftTip()
        }
        
    }
    
    @objc
    private func clearAll() {
        dismissTip()
    }
    
    
    @objc
    private func showGuide() {
        let checkVC = SensorCheckViewController()
        checkVC.state = .fix
        self.view.superview?.paretViewController()?.navigationController?.pushViewController(checkVC, animated: true)
    }
    
    private var zeroCount = 0 //统计佩戴完成次数，当连续几次收到佩戴完成判断佩戴合格
    //MARK:- delegate
    func checkWear(value: UInt8) {
        if value == 0 {
            zeroCount += 1
            if zeroCount > 4 {
                zeroCount = 0
                RelaxManager.shared.clearBLE()
                DispatchQueue.main.async {
                    self.waitAnimationView.pause()
                    self.doneOrSkip(isDone: true)
                    self.transToRightTip()
                }
            }
        } else {
            zeroCount = 0
        }
    }
}
