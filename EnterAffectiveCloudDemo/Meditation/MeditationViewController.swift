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
import RxSwift

class MeditationViewController: UIViewController, CheckSensorTipDelegate, MeditationExitDelegate {
    

    @IBOutlet weak var hiddenTitle: UILabel!
    @IBOutlet weak var scrollViewTitle: UILabel!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var coherenceView: RealtimeCoherenceView!
    @IBOutlet weak var pleasureView: RealtimePleasureView!
    
    @IBOutlet weak var shadowView: BackgroundView!
    @IBOutlet weak var batteryBtn: UIButton!
    @IBOutlet weak var drawerView: DrawerView!
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
    public var isCheckSensor = false
    private var bIsFirstTime = true
    private var bIsEnd = false
    private var bIsChecked = false
    private let dashboardIndexView = DashboardIndexView()
    public var isErrorViewShowing: Bool = false
    private var currentErrorType: ErrorType = .bluetooth
    private var service: MeditationService?
    private let dispose = DisposeBag()
    private var reportModel: MeditationReportModel = MeditationReportModel()
    private var _vcState: ChildVCState = .hidden  //view的状态
    private let timeLabel = UILabel()
    private var audioProgressView: AudioProgress = AudioProgress()
    private var audioButton: UIButton = UIButton()
    private var checkTip: CheckSensorTipViewController?
    private var meditateExit: MeditateExit?
    var bIsReCheck = false // 体验过程中是否佩戴检测检测
    override func viewDidLoad() {
        super.viewDidLoad()
        errorView.fixBtn.addTarget(self, action: #selector(errorConnect(sender:)), for: .touchUpInside)
        service = MeditationService(self)
        service?.reportModel = self.reportModel
        drawerView.rx_vcState.asObservable()
            .subscribe(onNext: {[weak self] (changed) in
                guard let self = self else {return}
                self.vcState = changed
        }).disposed(by: dispose)
        
        // Do any additional setup after loading the view.
        addGradiantColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        RelaxManager.shared.delegate = service
        BLEService.shared.bleManager.delegate = service
        if bIsFirstTime {
            dashboardIndexView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9568627451, blue: 0.9647058824, alpha: 1)
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
            let url = FTRemoteConfig.shared.getConfig(key: .eegService)!
            brainView.infoUrlString = url
            brainView.observe(with: leftArray, right: rightArray)//开始观察
            
            spectrumView.bgColor = #colorLiteral(red: 0.9490196078, green: 0.9568627451, blue: 0.9843137255, alpha: 1)
            spectrumView.mainColor = #colorLiteral(red: 0.2941176471, green: 0.3647058824, blue: 0.8, alpha: 1)
            spectrumView.infoUrlString = FTRemoteConfig.shared.getConfig(key: .brainService)!
            spectrumView.observe(with: (0.1, 0.28, 0.59, 0.02, 0.1))
            spectrumView.bgColor = .white
            
            
            heartView.bgColor = #colorLiteral(red: 1, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            heartView.mainColor = #colorLiteral(red: 0.8, green: 0.3215686275, blue: 0.4078431373, alpha: 1)
            heartView.textColor = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
            heartView.infoUrlString = FTRemoteConfig.shared.getConfig(key: .hrService)!
            heartView.observe(with: 65)
            
            hrvView.lineColor = Colors.yellowPrimary
            
            attentionView.bgColor = #colorLiteral(red: 0.7803921569, green: 1, blue: 0.8941176471, alpha: 1)
            attentionView.mainColor = #colorLiteral(red: 0.3725490196, green: 0.7764705882, blue: 0.5843137255, alpha: 1)
            attentionView.textColor = #colorLiteral(red: 0.09019607843, green: 0.09019607843, blue: 0.1490196078, alpha: 1)
            attentionView.infoUrlString = FTRemoteConfig.shared.getConfig(key: .attentionService)!
            attentionView.observe(with:39)
            
            relaxationView.bgColor = #colorLiteral(red: 0.8980392157, green: 0.9176470588, blue: 0.968627451, alpha: 1)
            relaxationView.mainColor = #colorLiteral(red: 0.2941176471, green: 0.3647058824, blue: 0.8, alpha: 1)
            relaxationView.textColor = #colorLiteral(red: 0.09019607843, green: 0.09019607843, blue: 0.1490196078, alpha: 1)
            relaxationView.infoUrlString = FTRemoteConfig.shared.getConfig(key: .relaxationService)!
            relaxationView.observe(with: 69)
            
            pressureView.bgColor = #colorLiteral(red: 1, green: 0.9058823529, blue: 0.9019607843, alpha: 1)
            pressureView.mainColor = #colorLiteral(red: 0.8, green: 0.3215686275, blue: 0.4078431373, alpha: 1)
            pressureView.textColor = #colorLiteral(red: 0.09019607843, green: 0.09019607843, blue: 0.1490196078, alpha: 1)
            pressureView.infoUrlString = FTRemoteConfig.shared.getConfig(key: .pressureService)!
            pressureView.observe(with: 3.6)
            
            arousalView.bgColor = #colorLiteral(red: 0.9921568627, green: 0.9450980392, blue: 0.9176470588, alpha: 1)
            arousalView.mainColor = #colorLiteral(red: 0.968627451, green: 0.7803921569, blue: 0.4941176471, alpha: 1)
            arousalView.textColor = #colorLiteral(red: 0.09019607843, green: 0.09019607843, blue: 0.1490196078, alpha: 1)
            arousalView.observe(with: 1.2)
            
            coherenceView.bgColor = #colorLiteral(red: 0.8980392157, green: 0.9176470588, blue: 0.968627451, alpha: 1)
            coherenceView.mainColor = #colorLiteral(red: 0.2941176471, green: 0.3647058824, blue: 0.8, alpha: 1)
            coherenceView.textColor = #colorLiteral(red: 0.09019607843, green: 0.09019607843, blue: 0.1490196078, alpha: 1)
            coherenceView.infoUrlString = FTRemoteConfig.shared.getConfig(key: .coherenceService)!
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
            bIsFirstTime = false
            
            hrvView.observe()
            hrvView.cornerRadius = 8
            
            var offset = 0
            if !Device.current.isiphoneX {
                offset = 30
            }
            drawerView.snp.makeConstraints {
                $0.left.equalToSuperview()
                $0.top.equalTo(self.view.snp.bottom).offset(-95+offset)
                $0.right.equalToSuperview()
                $0.height.equalToSuperview()
            }
            
            timeLabel.text = String.timeString(with:0.0)
            timeLabel.textColor = UIColor.white
            timeLabel.textAlignment = .center
            timeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 24)
                
            audioProgressView.needDownloadAudio = false
            audioProgressView.circleColor = Colors.green3.changeAlpha(to: 0.5)
            
            audioButton.setBackgroundImage(UIImage(named: "icon_audio_play"), for: .normal)
            self.view.insertSubview(timeLabel, belowSubview: shadowView)
            self.view.insertSubview(audioProgressView, belowSubview: shadowView)
            self.view.insertSubview(audioButton, belowSubview: shadowView)
            
            
            timeLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(228)
                $0.centerX.equalToSuperview()
            }
            
            audioProgressView.snp.makeConstraints {
                $0.width.height.equalTo(100)
                $0.centerX.equalToSuperview()
                $0.top.equalTo(self.timeLabel.snp.bottom).offset(16)
            }
            
            audioButton.snp.makeConstraints {
                $0.center.equalTo(audioProgressView)
                $0.width.height.equalTo(50)
            }
            
            setupTimer()
        }
        NotificationName.kFinishWithCloudServieDB.observe(sender: self, selector: #selector(self.finishWithCloudServiceHandle(_:)))
        if BLEService.shared.bleManager.state.isConnected {
            dismissErrorView(.bluetooth)
        } else {
            errorView.changeTipText(value: .bluetooth)
            currentErrorType = .network
        }
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        setLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        drawerView.viewShow(_vcState)
        if BLEService.shared.bleManager.state.isConnected  {
            if !bIsChecked || checkTip != nil { //判读是否出现提示
                bIsChecked = true
                if checkTip == nil {
                    self.timerPause()
                    self.audioState = false
                    checkTip = CheckSensorTipViewController()
                    RelaxManager.shared.delegate = checkTip
                    checkTip?.delegate = self
                    self.view.addSubview(checkTip!.view)
                    drawerView?.viewShow(.null, finishBlock: {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1, execute: {
                            self.checkTip!.showTip()
                        })
                    })
                } else {
                    //恢复中断的动画
                    RelaxManager.shared.delegate = checkTip
                    drawerView?.viewShow(.null)
                    if checkTip!.isLeftViewShowed {
                        checkTip?.waitAnimationView.play()
                        self.checkTip?.viewDot.layer.removeAllAnimations()
                        if let animate = self.checkTip?.scaleAnimation {
                            self.checkTip?.viewDot.layer.add(animate, forKey: "com.flowtime.scale")
                        }
                    } else {
                        if !self.checkTip!.rightSkipView.isHidden {
                            self.checkTip?.rightSkipView.play()
                        }
                    }
                }
            } else {
                if let _ = checkTip {
                    
                } else {
                    self.dismissErrorView(.bluetooth)
                    // 判断是否连接设备，连接设备就开始情感云
                    if BLEService.shared.bleManager.state.isConnected && !RelaxManager.shared.isWebSocketConnected {
                        if let use = self.service?.bIsUseService, use {
                            RelaxManager.shared.websocketConnect()
                        } else {
                            RelaxManager.shared.start(wbDelegate: service)
                        }
                    }
                    if RelaxManager.shared.isWebSocketConnected {
                        if isErrorViewShowing && currentErrorType == .poor && bIsReCheck {
                            service?.reCheck()
                        }
                    }
                }
            }
            if let per = BLEService.shared.bleManager.battery?.percentage  {
                let battery = per / 100
                var imageName: String?
                if battery > 0.9 {
                    imageName = "icon_battery_100_white"
                } else if battery > 0.7 && battery <= 0.9 {
                    imageName = "icon_battery_80_white"
                } else if battery > 0.5 && battery <= 0.7 {
                    imageName = "icon_battery_60_white"
                } else if battery > 0.2 && battery <= 0.5 {
                    imageName = "icon_battery_40_white"
                } else {
                    imageName = "icon_battery_10_white"
                }
                batteryBtn.setImage(UIImage(named: imageName!), for: .normal)
            }
//            if !RelaxManager.shared.isWebSocketConnected {
//
//                RelaxManager.shared.start(wbDelegate: service)
//            } else {
//                dismissErrorView(.network)
//                if self.isErrorViewShowing && currentErrorType == .poor {
//                    service?.reCheck()
//                }
//            }
        } else {
            batteryBtn.setImage(UIImage(named: "icon_flowtime_disconnected_white"), for: .normal)
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationName.kFinishWithCloudServieDB.remove(sender: self)
        BLEService.shared.bleManager.delegate = nil
        RelaxManager.shared.delegate = nil
        timerPause()
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
    
    private func addGradiantColor() {
        let _layer = CAGradientLayer()
        _layer.frame = self.view.bounds
        _layer.colors = [#colorLiteral(red: 0.0862745098, green: 0.4078431373, blue: 0.2666666667, alpha: 1).cgColor, #colorLiteral(red: 0.3215686275, green: 0.6352941176, blue: 0.4862745098, alpha: 1).cgColor]
        _layer.startPoint = CGPoint(x: 0.0, y: 0.0)
        _layer.endPoint = CGPoint(x: 0.0, y: 1.0)
        self.view.layer.insertSublayer(_layer, at: 0)
    }
    
    private var _audioPercent:CGFloat = 0
    //音乐播放比例
    public var audioPercent: CGFloat {
        get {
            return _audioPercent
        }
        set {
            _audioPercent = newValue
            if newValue > 0.000001 {
                audioProgressView.AudioProgressAnimate(percent: newValue)
            }
        }
    }
    
    private var _audioState = true
    //音乐播放状态
    public var audioState: Bool {
        get{
            return _audioState
        }
        set{
            _audioState = newValue
            DispatchQueue.main.async {
                if newValue {
                    self.audioButton.setBackgroundImage(UIImage(named: "icon_audio_pause"), for: .normal)
                } else {
                    self.audioButton.setBackgroundImage(UIImage(named: "icon_audio_play"), for: .normal)
                }
            }
        }
    }
    
    ///子视图位置
    public var vcState: ChildVCState {
        get {
            return _vcState
        }
        set {
            _vcState = newValue
            if newValue == .hidden {
                self.hiddenTitle.isHidden = false
                self.errorView.isHidden = true
                self.scrollViewTitle.isHidden = true
                //self.wearView.isHidden = true
            } else {
                self.hiddenTitle.isHidden = true
                self.scrollViewTitle.isHidden = false
                self.errorView.isHidden = false
                //self.wearView.isHidden = false
            }
            if newValue == .showAll {
                self.editBtn.isHidden = false
                self.scrollView.isScrollEnabled = true
            } else {
                self.editBtn.isHidden = true
                self.scrollView.isScrollEnabled = false
            }
        }
    }
    
    /// 显示错误视图
    /// - Parameter errorType: 错误类型
    public func showErrorView(_ errorType: ErrorType) {
        if bIsEnd {
            return
        }
        if !isErrorViewShowing {
            errorView.changeTipText(value: errorType)
            DispatchQueue.main.async {
                switch errorType {
                case .bluetooth:
                    if self.isCheckSensor {
                        self.drawerView.viewShow(.hidden)
                    }
                    self.currentErrorType = .bluetooth
                    self.setErrorMessage(text: "蓝牙连接断开")
                    UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut, animations: {
                        self.errorView.snp.updateConstraints{
                            $0.height.equalTo(162)
                        }
                        
                        self.view.layoutIfNeeded()
                    }, completion:  {
                        (complete) in
                        self.isErrorViewShowing = true
                        self.containerHeight.constant = 1700
                    })
                case .network:
                    self.currentErrorType = .network
                    self.setErrorMessage(text: "网络连接错误")
                    UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut, animations: {
                        self.errorView.snp.updateConstraints{
                            $0.height.equalTo(162)
                        }
                        
                        self.view.layoutIfNeeded()
                    }, completion: {
                        (complete) in
                        self.isErrorViewShowing = true
                        self.containerHeight.constant = 1700
                    })
                case .poor:
                    self.currentErrorType = .poor
                    self.setErrorMessage(text: "信号质量差")
                    UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseInOut, animations: {
                        self.errorView.snp.updateConstraints{
                            $0.height.equalTo(162)
                        }
                        
                        self.view.layoutIfNeeded()
                    }, completion:  {
                        (complete) in
                        self.isErrorViewShowing = true
                        self.containerHeight.constant = 1700
                    })
                }
            }
        } else {
            if currentErrorType == .poor {
                currentErrorType = errorType
                errorView.changeTipText(value: errorType)
                if errorType == .bluetooth {
                    self.setErrorMessage(text: "蓝牙连接断开")
                } else if errorType == .network {
                    self.setErrorMessage(text: "网络连接错误")
                }
            } else if currentErrorType == .network && errorType == .bluetooth{
                currentErrorType = errorType
                errorView.changeTipText(value: errorType)
                self.setErrorMessage(text: "蓝牙连接断开")
            }
        }
        
    }
    
    func setErrorMessage(text: String) {
        self.brainView.showTip(text: text)
        self.spectrumView.showTip(text: text)
        self.heartView.showTip(text: text)
        self.attentionView.showTip(text: text)
        self.relaxationView.showTip(text: text)
        self.pressureView.showTip(text: text)
        self.arousalView.showTip(text: text)
        self.coherenceView.showTip(text: text)
        self.pleasureView.showTip(text: text)
        self.hrvView.showTip(text: text)
    }
    
    
    /// 错误视图隐藏
    /// - Parameter errType: 错误类型
    public func dismissErrorView(_ errType: ErrorType) {
        if errType == .bluetooth && (currentErrorType == .poor || currentErrorType == .network) {
            return
        }
        if errType == .network && currentErrorType == .poor {
            return
        }
        self.isErrorViewShowing = false
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.errorView.snp.updateConstraints{
                    $0.height.equalTo(0)
                }
                self.view.layoutIfNeeded()
            }, completion: {
                (complete) in
                self.containerHeight.constant = 1620
            })
        }
       
    }
    
    /// 结束体验
    func finishMeditation()  {
        if let cTimer = service?.countTimer {
            if cTimer.isValid {
                cTimer.invalidate()
            }
        }
        
        if RelaxManager.shared.isWebSocketConnected {
            if countDownNum > Double(Preference.meditationTime)  {
                SVProgressHUD.show(withStatus: "正在生成报表")
                service?.finish()
            } else {
                self.navigationController?.dismiss(animated: true, completion: {
                    SVProgressHUD.showError(withStatus: "体验时常过短,无报表生成")
                })

                RelaxManager.shared.close()
            }
        } else {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    public var timer: Timer?
    private var countDownNum = 0.0
    private var _countDownNum = Preference.noMusicMeditationDuration
    private var isAlarming = false
    private var _player: LocalPlayer?
    private func setupTimer() {
        clean()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
            guard let `self` = self else { return  }
            if !self.audioState {
                self.audioState = true
            }
            self.timeLabel.text = String.timeString(with: self.countDownNum)
            if self.audioPercent < 1 {
                self.audioPercent = CGFloat(self.countDownNum) / CGFloat(self._countDownNum)
            }
            //self.audioPercent = CGFloat(self.countDownNum) / CGFloat(self._countDownNum)
            if self.countDownNum == self._countDownNum {
                self.audioPercent = 1
                if let path = Bundle.main.path(forResource: Preference.meditationSound ?? "Unknow", ofType: "mp3") {
                    if let url = URL(string: path) {
                        let player = SoundPlayer(url, soundID: 1)
                        player.play()
                    }
                    self.isAlarming = true
                }
            }
            self.countDownNum += 1
        })
        RunLoop.main.add(timer!, forMode: .common)
    }
     
     func timerPause() {
         self.audioState = false
         self.timer?.fireDate = Date.distantFuture
     }
     
     func timerContinue() {
         self.audioState = true
         self.timer?.fireDate = Date.distantPast
     }
     
     func clean() {
         self._player?.stop()
         self.timer?.invalidate()
         self.timer = nil
         countDownNum = 0
     }
    
    /// meditation 退出的代理方法
    func meditationExit() {
        //service?.finish()
        finishMeditation()
    }

    func cancelAction() {
        self.meditateExit?.removeFromSuperview()
        self.meditateExit = nil
    }
    
    /// 佩戴检测代理
    func dismissVC() {
        isCheckSensor = true
        drawerView?.viewShow(.hidden)
        timerContinue()
        //nonbiodataService?.audioPlayer?.play()

        audioState = true
        
        RelaxManager.shared.delegate = service
        checkTip?.delegate = nil
        checkTip = nil
        //
        // 判断是否连接设备，连接设备就开始情感云
        if BLEService.shared.bleManager.state.isConnected && !RelaxManager.shared.isWebSocketConnected {
            dismissErrorView(.bluetooth)
            if let service = self.service, service.bIsUseService {
                RelaxManager.shared.websocketConnect()
            } else {
                RelaxManager.shared.start(wbDelegate: service)

            }
            self.brainView.showProgress()
            self.spectrumView.showProgress()
            self.heartView.showProgress()
            self.attentionView.showProgress()
            self.relaxationView.showProgress()
            self.pressureView.showProgress()
            self.arousalView.showProgress()
            self.coherenceView.showProgress()
            self.pleasureView.showProgress()
            self.hrvView.showProgress()
        }
        if RelaxManager.shared.isWebSocketConnected {
            if isErrorViewShowing && currentErrorType == .poor && bIsReCheck {
                service?.reCheck()
            }
        }
    }
    
    /// 连接设备逻辑
    func connectMethod() {
        let controller = DeviceStatusViewController()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func editBtnPressed(_ sender: UIButton) {
        if sender.titleLabel?.text == "编辑" {
            sender.setTitle("完成", for: .normal)
            self.drawerView.addSubview(dashboardIndexView)
            dashboardIndexView.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.height.equalTo(800)
                $0.top.equalTo(self.editBtn.snp.bottom)
            }
        } else {
            sender.setTitle("编辑", for: .normal)
            if let _ = dashboardIndexView.superview {
                dashboardIndexView.removeFromSuperview()
                setLayout() 
            }
        }
    }
    
    @IBAction func dismissMeditation(_ sender: Any) {
        for e in self.view.subviews {
            if e.isKind(of: MeditateExit.classForCoder()) {
                return
            }
        }

        if countDownNum >= Double(Preference.meditationTime) {
            if let bio = service, bio.bIsUseService {
                if RelaxManager.shared.isWebSocketConnected && !bio.bIsQualityPoor {
                    meditateExit = MeditateExit(frame: self.view.bounds, exitType: .finish)
                } else {
                    meditateExit = MeditateExit(frame: self.view.bounds, exitType: .disconnect)
                }
            } else {
                meditateExit = MeditateExit(frame: self.view.bounds, exitType: .finish)
            }
        } else {
            meditateExit = MeditateExit(frame: self.view.bounds, exitType: .early)
        }

        meditateExit?.delegate = self
        self.view.addSubview(meditateExit!)
        meditateExit?.showView()
//        let action = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//        let okBtn = UIAlertAction(title: "确定", style: .default) { (action) in
//            self.finishMeditation()
//        }
//        if let times = service?.meditationModel.startTime,
//        Int(Date().timeIntervalSince(times)) > Preference.meditationTime  {
//            let alert = UIAlertController(title: "结束体验", message: "结束体验并获取分析报告", preferredStyle: .alert)
//            alert.addAction(action)
//            alert.addAction(okBtn)
//            self.present(alert, animated: true, completion: nil)
//        } else {
//            let alert = UIAlertController(title: "结束体验", message: "体验时长不足无法生成报表,确定退出?", preferredStyle: .alert)
//            alert.addAction(action)
//            alert.addAction(okBtn)
//            self.present(alert, animated: true, completion: nil)
//        }
            
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
            SyncManager.shared.sync()
            self.bIsEnd = true
            let parentTabbarVC = self.navigationController?.presentingViewController
            self.navigationController?.dismiss(animated: true) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3) {
                    if let tabbarVC = parentTabbarVC as? UITabBarController {
                        let navigationVC2 = tabbarVC.viewControllers![1] as? UINavigationController
                        let report = navigationVC2?.viewControllers[0] as? Statistics2ViewController
                        report?.isExample = false
                        report?.listIndex = 0
                        navigationVC2?.popToRootViewController(animated: true)
                        tabbarVC.selectedIndex = 1
                    }
                }
            }
        }
    }
    
    /// 异常按钮处理
    @objc func errorConnect(sender: UIButton){
        sender.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
            sender.isEnabled = true
        })
        if !BLEService.shared.bleManager.state.isConnected {
            connectMethod()
        } else {
            if !RelaxManager.shared.isWebSocketConnected {
                RelaxManager.shared.websocketConnect()
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                    RelaxManager.shared.sessionRestore()

                }
                return
            }
            if currentErrorType == .poor {
                bIsReCheck = true
                let checkVC = SensorCheckViewController()
                checkVC.state = .fix
                self.navigationController?.pushViewController(checkVC, animated: true)
            }
            
        }
    }
    @IBAction func bleAction(_ sender: Any) {
        connectMethod()
    }
    
    @objc
    private func enterForeground() {
        self.brainView.restoreAnimation()
        self.spectrumView.restoreAnimation()
        self.heartView.restoreAnimation()
        self.hrvView.restoreAnimation()
        self.relaxationView.restoreAnimation()
        self.pressureView.restoreAnimation()
        self.attentionView.restoreAnimation()
        self.arousalView.restoreAnimation()
        self.coherenceView.restoreAnimation()
        self.pleasureView.restoreAnimation()
        checkTip?.waitAnimationView.play()
        self.checkTip?.viewDot.layer.removeAllAnimations()
        if let animate = self.checkTip?.scaleAnimation {
            self.checkTip?.viewDot.layer.add(animate, forKey: "com.flowtime.scale")
        }
    }
    
    @objc
    private func enterBackground() {
        let y = drawerView.frame.origin.y
        let offset = y - self.view.bounds.height
        drawerView.snp.updateConstraints {
            $0.top.equalTo(self.view.snp.bottom).offset(offset)
        }
    }
}
