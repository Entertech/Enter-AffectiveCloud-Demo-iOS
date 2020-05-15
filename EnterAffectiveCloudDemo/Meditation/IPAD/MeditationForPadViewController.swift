//
//  MeditationForPadViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/1/14.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI
import EnterBioModuleBLEUI
import EnterBioModuleBLE
import SVProgressHUD


class MeditationForPadViewController: UIViewController {

    @IBOutlet weak var affectiveLineView: AffectiveRealtimeView!
    @IBOutlet weak var emotionView: EmotionDemoView!
    @IBOutlet weak var errorView: ErrorTipView!
    @IBOutlet weak var coherenceView: RealtimeCoherenceView!
    @IBOutlet weak var pleasureView: RealtimePleasureView!
    @IBOutlet weak var arousalView: RealtimeArousalView!
    @IBOutlet weak var pressureView: RealtimePressureView!
    @IBOutlet weak var attentionView: RealtimeAttentionView!
    @IBOutlet weak var relaxationView: RealtimeRelaxationView!
    @IBOutlet weak var spectrumView: RealtimeBrainwaveSpectrumView!
    @IBOutlet weak var brainView: RealtimeBrainwaveView!
    @IBOutlet weak var heartView: RealtimeHeartRateView!
    @IBOutlet weak var hrvView: RealtimeHRVView!
    
    public var isErrorViewShowing: Bool = true
    private var currentErrorType: ErrorType = .network
    private var service: MeditationService?
    private let reportModel = MeditationReportModel()
    private var isEnd = false
    override func viewDidLoad() {
        super.viewDidLoad()
        errorView.fixBtn.addTarget(self, action: #selector(errorConnect(sender:)), for: .touchUpInside)
        service?.reportModel = self.reportModel
        service = MeditationService(self)
        setNavigation()
        setUI()
    }
    
    
    func setUI() {
        
        heartView.bgColor = #colorLiteral(red: 1, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        heartView.textColor = #colorLiteral(red: 0.2588235294, green: 0.2823529412, blue: 0.4196078431, alpha: 1)
        heartView.mainColor = #colorLiteral(red: 0.4980392157, green: 0.3490196078, blue: 0.3764705882, alpha: 1)
        heartView.minAndMaxOnBottom = true
        
        brainView.bgColor = .white
        brainView.mainColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        
        spectrumView.bgColor = .white
        spectrumView.mainColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        spectrumView.lineColors = (#colorLiteral(red: 1, green: 0.7725490196, blue: 0.4352941176, alpha: 1),#colorLiteral(red: 0.9843137255, green: 0.6117647059, blue: 0.5960784314, alpha: 1),#colorLiteral(red: 0.3725490196, green: 0.7764705882, blue: 0.5843137255, alpha: 1),#colorLiteral(red: 0.368627451, green: 0.4588235294, blue: 1, alpha: 1),#colorLiteral(red: 0.3333333333, green: 0.3568627451, blue: 0.4980392157, alpha: 1))
        
        hrvView.cornerRadius = 8
        hrvView.mainColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        
        attentionView.mainColor = #colorLiteral(red: 0.3215686275, green: 0.6352941176, blue: 0.4862745098, alpha: 1)
        attentionView.bgColor = #colorLiteral(red: 0.8862745098, green: 1, blue: 0.9450980392, alpha: 1)
        relaxationView.mainColor = #colorLiteral(red: 0, green: 0.3921568627, blue: 1, alpha: 1)
        relaxationView.bgColor = #colorLiteral(red: 0.8980392157, green: 0.9176470588, blue: 0.968627451, alpha: 1)
        pressureView.mainColor = #colorLiteral(red: 1, green: 0.4, blue: 0.5098039216, alpha: 1)
        pressureView.bgColor = #colorLiteral(red: 1, green: 0.9058823529, blue: 0.9019607843, alpha: 1)
        arousalView.mainColor = #colorLiteral(red: 1, green: 0.7725490196, blue: 0.4352941176, alpha: 1)
        arousalView.bgColor = #colorLiteral(red: 0.9921568627, green: 0.9450980392, blue: 0.9176470588, alpha: 1)
        pleasureView.mainColor = #colorLiteral(red: 0.4, green: 0.2823529412, blue: 1, alpha: 1)
        pleasureView.bgColor = #colorLiteral(red: 0.937254902, green: 0.8980392157, blue: 0.968627451, alpha: 1)
        coherenceView.mainColor = #colorLiteral(red: 0, green: 0.3921568627, blue: 1, alpha: 1)
        coherenceView.bgColor = #colorLiteral(red: 0.8980392157, green: 0.9176470588, blue: 0.968627451, alpha: 1)
        
        heartView.observe()
        brainView.observe()
        spectrumView.observe()
        hrvView.observe()
        attentionView.observe()
        relaxationView.observe()
        pressureView.observe()
        arousalView.observe()
        pleasureView.observe()
        coherenceView.observe()
        
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
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationName.kFinishWithCloudServieDB.observe(sender: self, selector: #selector(self.finishWithCloudServiceHandle(_:)))
        BLEService.shared.bleManager.delegate = service
        if BLEService.shared.bleManager.state.isConnected {
            if !RelaxManager.shared.isWebSocketConnected {
                
                RelaxManager.shared.start(wbDelegate: service)
            } else {
                dismissErrorView(.network)
            }
            dismissErrorView(.bluetooth)
        } else {
            errorView.changeTipText(value: .bluetooth)
            currentErrorType = .network
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationName.kFinishWithCloudServieDB.remove(sender: self)
        BLEService.shared.bleManager.delegate = nil
    }
    
    /// 设置navigation item
    private func setNavigation() {
        let leftItem = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 28))
        leftItem.layer.cornerRadius = 14
        leftItem.layer.masksToBounds = true
        leftItem.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        leftItem.setTitle("连接设备", for: .normal)
        leftItem.setTitleColor(.white, for: .normal)
        leftItem.setBackgroundImage(UIColor.colorWithHexString(hexColor: "4B5DCC").image(), for: .normal)
        leftItem.setTitleColor(#colorLiteral(red: 0.2941176471, green: 0.3647058824, blue: 0.8, alpha: 1), for: .highlighted)
        leftItem.setBackgroundImage(UIColor.colorWithHexString(hexColor: "F1F3f5").image(), for: .highlighted)
        leftItem.addTarget(self, action: #selector(showConnection), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem(customView: leftItem)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightItem = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        rightItem.addTarget(self, action: #selector(finishMeditation), for: .touchUpInside)
        rightItem.setImage(#imageLiteral(resourceName: "close_blue"), for: .normal)
        let rightBarButtonItem = UIBarButtonItem(customView: rightItem)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func showConnection() {
        let ble = BLEService.shared.bleManager
        let connection = BLEConnectViewController(bleManager: ble)
        connection.cornerRadius = 6
        connection.mainColor = UIColor(red: 0, green: 100.0/255.0, blue: 1, alpha: 1)

        self.present(connection, animated: true, completion: nil)
    }
    
    
    @objc private func finishMeditation() {
        if RelaxManager.shared.isWebSocketConnected {
            if let times = service?.meditationModel.startTime,
                Int(Date().timeIntervalSince(times)) > Preference.meditationTime  {
                SVProgressHUD.show(withStatus: "正在生成报表")
                service?.finish()
            } else {
                SVProgressHUD.showError(withStatus: "体验时常过短,无报表生成")
                
            }
        } else {

            SVProgressHUD.show(withStatus: "情感云未连接无法生成报表")
        }
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
                case .poor:
                    break
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
            
            let data = MeditationRepository.query(Preference.userID)
            if let data = data {
                let report = MainReportViewController()
                report.meditationDB = data.last
                report.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(report, animated: true)
            }
        }
    }

}
