//
//  MeditationViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/14.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI
import EnterBioModuleBLEUI
import SVProgressHUD

class MeditationViewController: UIViewController {
    
    @IBOutlet weak var coherenceView: RealtimeCoherenceView!
    @IBOutlet weak var pleasureView: RealtimePleasureView!
    
    @IBOutlet weak var rightAndLeftSpectrumView: RealtimeLeftAndRightSpectrumView!
    @IBOutlet weak var hrvView: RealtimeHRVView!
    @IBOutlet weak var errorView: ErrorTipView!
    @IBOutlet weak var heartView: RealtimeHeartRateView!
    @IBOutlet weak var heartBoard: UIView!
    @IBOutlet weak var brainBoard: UIView!
    @IBOutlet weak var brainView: RealtimeBrainwaveView!
    @IBOutlet weak var spectrumView: RealtimeBrainwaveSpectrumView!
    @IBOutlet weak var emotionBoard: UIView!
    @IBOutlet weak var attentionView: RealtimeAttentionView!
    @IBOutlet weak var relaxationView: RealtimeRelaxationView!
    @IBOutlet weak var pressureView: RealtimePressureView!
    @IBOutlet weak var arousalView: RealtimeArousalView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    private var isFirstTime = true
    private var isEnd = false
    private let dashboardIndexView = DashboardIndexView()
    private var isErrorViewShowing: Bool = true
    private var currentErrorType: ErrorType = .network
    private var service: MeditationService?
    private var reportModel: MeditationReportModel = MeditationReportModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        errorView.fixBtn.addTarget(self, action: #selector(errorConnect(sender:)), for: .touchUpInside)
        service = MeditationService(self)
        service?.reportModel = self.reportModel
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if isFirstTime {
            self.view.backgroundColor = UIColor.colorWithHexString(hexColor: "f1f4f6")
            brainView.mainColor = #colorLiteral(red: 0.2941176471, green: 0.3647058824, blue: 0.8, alpha: 1)    //主色调
            brainView.textColor = .black    //文字颜色
            brainView.bgColor = .white
            var leftArray: [Float] = []
            for _ in 0...200 {
                let random: Int = Int(arc4random_uniform(200))
                leftArray.append(Float(random - 100))
            }
            var rightArray: [Float] = []
            for _ in 0...200 {
                let random: Int = Int(arc4random_uniform(200))
                rightArray.append(Float(random - 100))
            }
            brainView.observe(with: leftArray, right: rightArray)//开始观察
            
            spectrumView.bgColor = #colorLiteral(red: 0.9490196078, green: 0.9568627451, blue: 0.9843137255, alpha: 1)
            spectrumView.mainColor = #colorLiteral(red: 0.2941176471, green: 0.3647058824, blue: 0.8, alpha: 1)
            spectrumView.observe(with: (0.1, 0.28, 0.59, 0.02, 0.1))
            spectrumView.bgColor = .white
            
            rightAndLeftSpectrumView.bgColor = #colorLiteral(red: 0.9490196078, green: 0.9568627451, blue: 0.9843137255, alpha: 1)
            rightAndLeftSpectrumView.mainColor = #colorLiteral(red: 0.2941176471, green: 0.3647058824, blue: 0.8, alpha: 1)
            rightAndLeftSpectrumView.leftColor = #colorLiteral(red: 0.3725490196, green: 0.7764705882, blue: 0.5843137255, alpha: 1)
            rightAndLeftSpectrumView.rightColor = #colorLiteral(red: 0.8, green: 0.3215686275, blue: 0.4078431373, alpha: 1)
            rightAndLeftSpectrumView.title = lang("左右脑波节律")
            rightAndLeftSpectrumView.observe()
            rightAndLeftSpectrumView.bgColor = .white
            
            
            heartView.bgColor = #colorLiteral(red: 1, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            heartView.mainColor = #colorLiteral(red: 0.8, green: 0.3215686275, blue: 0.4078431373, alpha: 1)
            heartView.textColor = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
            heartView.observe(with: 65)
            
            attentionView.bgColor = #colorLiteral(red: 0.7803921569, green: 1, blue: 0.8941176471, alpha: 1)
            attentionView.mainColor = #colorLiteral(red: 0.3725490196, green: 0.7764705882, blue: 0.5843137255, alpha: 1)
            attentionView.textColor = #colorLiteral(red: 0.09019607843, green: 0.09019607843, blue: 0.1490196078, alpha: 1)
            attentionView.observe(with:39)
            
            relaxationView.bgColor = #colorLiteral(red: 0.8980392157, green: 0.9176470588, blue: 0.968627451, alpha: 1)
            relaxationView.mainColor = #colorLiteral(red: 0.2941176471, green: 0.3647058824, blue: 0.8, alpha: 1)
            relaxationView.textColor = #colorLiteral(red: 0.09019607843, green: 0.09019607843, blue: 0.1490196078, alpha: 1)
            relaxationView.observe(with: 69)
            
            pressureView.bgColor = #colorLiteral(red: 1, green: 0.9058823529, blue: 0.9019607843, alpha: 1)
            pressureView.mainColor = #colorLiteral(red: 0.8, green: 0.3215686275, blue: 0.4078431373, alpha: 1)
            pressureView.textColor = #colorLiteral(red: 0.09019607843, green: 0.09019607843, blue: 0.1490196078, alpha: 1)
            pressureView.observe(with: 3.6)
            
            arousalView.bgColor = #colorLiteral(red: 0.9921568627, green: 0.9450980392, blue: 0.9176470588, alpha: 1)
            arousalView.mainColor = #colorLiteral(red: 0.968627451, green: 0.7803921569, blue: 0.4941176471, alpha: 1)
            arousalView.textColor = #colorLiteral(red: 0.09019607843, green: 0.09019607843, blue: 0.1490196078, alpha: 1)
            arousalView.observe(with: 1.2)
            
            coherenceView.bgColor = #colorLiteral(red: 0.8980392157, green: 0.9176470588, blue: 0.968627451, alpha: 1)
            coherenceView.mainColor = #colorLiteral(red: 0.2941176471, green: 0.3647058824, blue: 0.8, alpha: 1)
            coherenceView.textColor = #colorLiteral(red: 0.09019607843, green: 0.09019607843, blue: 0.1490196078, alpha: 1)
            coherenceView.observe(with: 28)
            
            pleasureView.bgColor = #colorLiteral(red: 0.7803921569, green: 1, blue: 0.8941176471, alpha: 1)
            pleasureView.mainColor = #colorLiteral(red: 0.3725490196, green: 0.7764705882, blue: 0.5843137255, alpha: 1)
            pleasureView.textColor = #colorLiteral(red: 0.09019607843, green: 0.09019607843, blue: 0.1490196078, alpha: 1)
            pleasureView.observe(with: 3.3)
            
            brainView.showTip()
            spectrumView.showTip()
            heartView.showTip()
            attentionView.showTip()
            relaxationView.showTip()
            arousalView.showTip()
            coherenceView.showTip()
            pleasureView.showTip()
            pressureView.showTip()
            hrvView.showTip()   
            isFirstTime = false
            
            hrvView.uploadCycle = UInt(Preference.kCloudServiceUploadCycle)
            hrvView.observe()
            hrvView.cornerRadius = 8
        
        }
        NotificationName.kFinishWithCloudServieDB.observe(sender: self, selector: #selector(self.finishWithCloudServiceHandle(_:)))
        if BLEService.shared.bleManager.state.isConnected {
            dismissErrorView(.bluetooth)
        } else {
            errorView.changeTipText(value: .bluetooth)
            currentErrorType = .network
        }
        setLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BLEService.shared.bleManager.delegate = service
        if BLEService.shared.bleManager.state.isConnected  {
            if !RelaxManager.shared.isWebSocketConnected {
                
                RelaxManager.shared.start(wbDelegate: service)
            } else {
                dismissErrorView(.network)
            }
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationName.kFinishWithCloudServieDB.remove(sender: self)
        BLEService.shared.bleManager.delegate = nil
    }


    private func setLayout() {

        let boardIndex = dashboardIndexView.dashboardIndex
        var viewArray: [UIView] = []
        let view1:UIView = UIView()
        let view2:UIView = UIView()
        let view3:UIView = UIView()
        viewArray.append(view1)
        viewArray.append(view2)
        viewArray.append(view3)
        for (index, e) in boardIndex.enumerated() {
           switch e {
           case .heart:
               viewArray[index] = heartBoard
           case .brainwave:
               viewArray[index] = brainBoard
           case .emotion:
               viewArray[index] = emotionBoard
           }
        }
        viewArray[1].snp.updateConstraints{
            $0.top.equalTo(self.errorView.snp.bottom).offset(16+viewArray[0].bounds.height+24)
        }

        viewArray[0].snp.updateConstraints{
            $0.top.equalTo(self.errorView.snp.bottom).offset(16)
        }

        viewArray[2].snp.updateConstraints{
            $0.top.equalTo(self.errorView.snp.bottom).offset(16+viewArray[1].bounds.height+24+viewArray[0].bounds.height+24)
        }
        self.view.layoutIfNeeded()
    }
    
    /// 显示错误视图
    /// - Parameter errorType: 错误类型
    public func showErrorView(_ errorType: ErrorType) {
        if isEnd {
            return
        }
        if !isErrorViewShowing {
            errorView.changeTipText(value: errorType)
            DispatchQueue.main.async {
                switch errorType {
                case .bluetooth:
                    
                    self.currentErrorType = .bluetooth
                    UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut, animations: {
                        self.errorView.snp.updateConstraints{
                            $0.height.equalTo(162)
                        }
                        self.view.layoutIfNeeded()
                    }, completion:  {
                        (complete) in
                        self.isErrorViewShowing = true
                        
                    })
                case .network:
                    
                    self.currentErrorType = .network
                    UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut, animations: {
                        self.errorView.snp.updateConstraints{
                            $0.height.equalTo(162)
                        }
                        self.view.layoutIfNeeded()
                    }, completion: {
                        (complete) in
                        self.isErrorViewShowing = true
                        
                    })
                }
            }
            
        }
        
    }
    
    
    /// 错误视图隐藏
    /// - Parameter errType: 错误类型
    public func dismissErrorView(_ errType: ErrorType) {
        if isErrorViewShowing && errType == .network {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                    self.errorView.snp.updateConstraints{
                        $0.height.equalTo(0)
                    }
                    self.view.layoutIfNeeded()
                }, completion: {
                    (complete) in
                    self.isErrorViewShowing = false
                })
            }
            
        } else {
            
            if isErrorViewShowing && currentErrorType == errType {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                        self.errorView.snp.updateConstraints{
                            $0.height.equalTo(0)
                        }
                        self.view.layoutIfNeeded()
                    }, completion: {
                        (complete) in
                        self.isErrorViewShowing = false
                    })
                }
            }
        }
    }
    
    /// 情感云断开提示后，点击的处理逻辑
    func dealErrorEvent(_ error: ErrorType) {
        if error == .bluetooth {
            try? BLEService.shared.bleManager.scanAndConnect(completion: nil)
        } else if error == .network {
            if !RelaxManager.shared.isWebSocketConnected {
                RelaxManager.shared.websocketConnect()
            }
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                RelaxManager.shared.sessionRestore()
            }
        }
    }
    
    /// 结束体验
    func finishMeditation()  {
        if RelaxManager.shared.isWebSocketConnected {
            if let times = service?.meditationModel.startTime,
                Int(Date().timeIntervalSince(times)) > Preference.meditationTime  {
                SVProgressHUD.show(withStatus: lang("正在生成报表"))
                service?.finish()
            } else {
                self.dismiss(animated: true) {
                    SVProgressHUD.showError(withStatus: lang("体验时常过短,无报表生成"))
                }
            }
        } else {

            self.dismiss(animated: true) {

            }
        }
    }

    @IBAction func editBtnPressed(_ sender: UIButton) {
        if sender.titleLabel?.text == lang("编辑") {
            sender.setTitle(lang("完成"), for: .normal)
            self.view.addSubview(dashboardIndexView)
            dashboardIndexView.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(800)
                $0.top.equalTo(self.editBtn.snp.bottom).offset(8)
            }
        } else {
            sender.setTitle(lang("编辑"), for: .normal)
            if let _ = dashboardIndexView.superview {
                dashboardIndexView.removeFromSuperview()
                setLayout() 
            }
        }
    }
    
    @IBAction func dismissMeditation(_ sender: Any) {
        let action = UIAlertAction(title: lang("取消"), style: .cancel, handler: nil)
        let okBtn = UIAlertAction(title: lang("确定"), style: .default) { (action) in
            self.finishMeditation()
        }
        if let times = service?.meditationModel.startTime,
        Int(Date().timeIntervalSince(times)) > Preference.meditationTime  {
            let alert = UIAlertController(title: lang("结束体验"), message: lang("结束体验并获取分析报告"), preferredStyle: .alert)
            alert.addAction(action)
            alert.addAction(okBtn)
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: lang("结束体验"), message: lang("体验时长不足无法生成报表,确定退出?"), preferredStyle: .alert)
            alert.addAction(action)
            alert.addAction(okBtn)
            self.present(alert, animated: true, completion: nil)
        }
            
    }
    
    /// 情感云结束体验通知处理
    ///
    /// - Parameter notification:
    @objc
    private func finishWithCloudServiceHandle(_ notification: Notification) {
        
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            if RelaxManager.shared.isWebSocketConnected {
                RelaxManager.shared.close()
            }
            self.isEnd = true
            self.dismiss(animated: true) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3) {

                    let data = MeditationRepository.query(Preference.userID)
                    if let data = data {
                        let report = MainReportViewController()
                        report.meditationDB = data.last
                        report.hidesBottomBarWhenPushed = true
                        UIViewController.currentViewController()?.navigationController?.pushViewController(report, animated: true)
                    }
                }
            }
        }
    }
    
    @objc func errorConnect(sender: UIButton){
        sender.isEnabled = false
        if !BLEService.shared.bleManager.state.isConnected {
            let ble = BLEService.shared.bleManager
            let connection = BLEConnectViewController(bleManager: ble)
            connection.cornerRadius = 6
            connection.mainColor = UIColor(red: 0, green: 100.0/255.0, blue: 1, alpha: 1)

            self.present(connection, animated: true, completion: nil)
        } else {
            if !RelaxManager.shared.isWebSocketConnected {
                RelaxManager.shared.websocketConnect()
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                    RelaxManager.shared.sessionRestore()
                    sender.isEnabled = true
                }
            }
            
        }
        
        
    }
}
