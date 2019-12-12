//
//  RecordViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/12/9.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import SVProgressHUD

class RecordViewController: UIViewController {
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    private var dimCount = 0
    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        if let chooseDim = TimeRecord.chooseDim {
            if dimCount < chooseDim.count {
                dimCount = chooseDim.count
                SVProgressHUD.showSuccess(withStatus: "提交成功")
            }
        }
        
        changeUI(isStop: true)
    }
    
    func setUI() {
        if let models = ACTagModel.shared.tagModels {
            let currentTag = ACTagModel.shared.currentTag
            titleLabel.text = models[currentTag].name_cn
        }
        
        navigationItem.title = "数据记录"
        tipLabel.textAlignment = .center
        recordBtn.layer.cornerRadius = 51
        recordBtn.layer.masksToBounds = true
    }


    @IBAction func recordPressed(_ sender: Any) {
        if let record = TimeRecord.time {
            if let last = record.last {
                if last.1 == .start {
                    let value: (Date, tagMark) = (Date(), .end)
                    TimeRecord.time?.append(value)
                    if let chooseDim = TimeRecord.chooseDim {
                        dimCount = chooseDim.count
                    } else {
                        TimeRecord.chooseDim = []
                        dimCount = 0
                    }
                    let chooseTagViewController = ChooseTagViewController()
                    self.navigationController?.pushViewController(chooseTagViewController, animated: true)
                    
                } else {
                    let value: (Date, tagMark) = (Date(), .start)
                    TimeRecord.time?.append(value)
                    changeUI(isStop: false)
                }
            } else {
                let value: (Date, tagMark) = (Date(), .start)
                TimeRecord.time?.append(value)
                changeUI(isStop: false)
            }
            
        } else {
            TimeRecord.time = []
            let value: (Date, tagMark) = (Date(), .start)
            TimeRecord.time?.append(value)
            changeUI(isStop: false)
        }
    }
    
    
    func changeUI(isStop: Bool) {
        if isStop {
            recordBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "4B5DCC")
            recordBtn.setTitle("开始记录", for: .normal)
            timerLabel.text = "00:00"
            timerLabel.isHidden = true
            tipLabel.text = "确定被试者已进入对应状态后再开始数据记录。"
            if timer?.isValid ?? false {
                timer?.invalidate()
                timer = nil
            }
            self.navigationItem.hidesBackButton = false
        } else {
            recordBtn.backgroundColor = UIColor.hexStringToUIColor(hex: "FF6682")
            recordBtn.setTitle("结束记录", for: .normal)
            var clock = 0
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                clock += 1
                let value = Int(clock)
                let left = value / 60
                let right = value % 60
                let timerStr = String(format: "%02d:%02d", left,right)
                self.timerLabel.text = timerStr
            }
            tipLabel.text = "一旦被试者不在对应状态请马上结束记录。"
            timerLabel.isHidden = false
            self.navigationItem.hidesBackButton = true
        }

    }
    
}
