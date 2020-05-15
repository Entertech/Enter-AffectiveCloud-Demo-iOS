//
//  SensorCheckViewController.swift
//  Flowtime
//
//  Created by Enter on 2020/3/31.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import Lottie

class SensorCheckViewController: UIViewController, CheckWearDelegate {

    enum CheckElement {
        case check // 检查时显示skip
        case fix // 修复时直接返回按钮
        case none
    }
    
    var state: CheckElement = .none
    var bIsShowed = true
    
    @IBOutlet weak var ScrollBgView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view7: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    private let animationView = AnimationView(name: "welldone")
    private let sensorView = AnimationView(name: "checking")
    private let checkingLabel = UILabel()
    private let welldoneLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        RelaxManager.shared.delegate = self
        if BLEService.shared.bleManager.state.isConnected {
            RelaxManager.shared.setupBLE()
        }
        sensorView.play()
        if bIsShowed {
            bIsShowed = false
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        RelaxManager.shared.delegate = nil
    }
    
    private func setUI() {
        if state == .check {
            backBtn.isHidden = true
            skipBtn.isHidden = false
        } else if state == .fix {
            backBtn.isHidden = false
            skipBtn.isHidden = true
        }
        skipBtn.setTitleColor(Colors.btn1, for: .normal)
        ScrollBgView.backgroundColor = Colors.bg2
        view1.backgroundColor = Colors.bgZ1
        view2.backgroundColor = Colors.bgZ1
        view3.backgroundColor = Colors.bgZ1
        view4.backgroundColor = Colors.bgZ1
        view5.backgroundColor = Colors.bgZ1
        view6.backgroundColor = Colors.bgZ1
        view7.backgroundColor = Colors.bgZ1
        label1.textColor = Colors.textLv1
        label2.textColor = Colors.textLv1
        label3.textColor = Colors.textLv1
        label4.textColor = Colors.textLv1
        label5.textColor = Colors.textLv1
        label6.textColor = Colors.textLv1
        label7.textColor = Colors.textLv1
        
        self.viewMain.addSubview(sensorView)
        sensorView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(16)
            $0.width.equalTo(100)
            $0.height.equalTo(40)
        }
        sensorView.animationSpeed = 1
        sensorView.loopMode = .loop
        
        self.viewMain.addSubview(checkingLabel)
        checkingLabel.text = "Checking..."
        checkingLabel.textColor = Colors.red4
        checkingLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        checkingLabel.snp.makeConstraints {
            $0.bottom.equalTo(-20)
            $0.centerX.equalToSuperview()
        }
        
        self.view.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(sensorView.snp.centerY)
        }
        animationView.animationSpeed = 1
        animationView.loopMode = .playOnce
        animationView.isHidden = true
        welldoneLabel.text = "Well done!"
        welldoneLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        welldoneLabel.textColor = UIColor.colorWithHexString(hexColor: "5FC695")
        self.view.addSubview(welldoneLabel)
        welldoneLabel.snp.makeConstraints {
            $0.top.equalTo(animationView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        welldoneLabel.isHidden = true
    }

    // MARK: - action
    @IBAction func skipAction(_ sender: Any) {
        let medition = MeditationViewController()
        self.navigationController?.pushViewController(medition, animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - listener
    private var zeroCount = 0 //统计佩戴完成次数，当连续几次收到佩戴完成判断佩戴合格
    func checkWear(value: UInt8) {
        if value == 0 {
            zeroCount += 1
            if zeroCount > 2 {
                zeroCount = 0
                DispatchQueue.main.async {
                    RelaxManager.shared.delegate = nil
                    self.animationView.isHidden = false
                    self.welldoneLabel.isHidden = false
                    self.skipBtn.isEnabled = false
                    self.animationView.play()
                    self.sensorView.isHidden = true
                    self.sensorView.stop()
                    self.checkingLabel.isHidden = true
                    if self.state == .check {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.5) {
                            let medition = MeditationViewController()
                            self.navigationController?.pushViewController(medition, animated: true)
                        }
                        
                    }
                }
            }
            
        } else {
            zeroCount = 0
        }
    }
}
