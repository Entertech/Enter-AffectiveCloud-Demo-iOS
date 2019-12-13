//
//  ExperimentCenterViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/12/9.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import SVProgressHUD
import EnterAffectiveCloudUI
import RxSwift

class ExperimentCenterViewController: UIViewController {

    @IBOutlet weak var headBar: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var backgroundView: BackgroundView!
    @IBOutlet weak var drawerView: DrawerView!
    @IBOutlet weak var pressureView: RealtimePressureView!
    @IBOutlet weak var brianView: RealtimeBrainwaveView!
    @IBOutlet weak var spectrumView: RealtimeBrainwaveSpectrumView!
    @IBOutlet weak var attentionView: RealtimeAttentionView!
    @IBOutlet weak var relaxationView: RealtimeRelaxationView!
    @IBOutlet weak var heartView: RealtimeHeartRateView!
    @IBOutlet weak var scrollView: UIScrollView!
    public var _vcState: ChildVCState = .hidden
    private var isFirstTime = true
    private var dispose = DisposeBag()
    private var service: MeditationService?
    private var reportModel: MeditationReportModel = MeditationReportModel()
    
    
    //子视图位置
    var vcState: ChildVCState {
        get {
            return _vcState
        }
        set {
            _vcState = newValue
            if newValue == .hidden {
               
            } else {

            }
            if newValue == .showAll {
                self.scrollView.isScrollEnabled = true
            } else {
                self.scrollView.isScrollEnabled = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startBtn.layer.cornerRadius = 22
        startBtn.layer.masksToBounds = true
        service = MeditationService(self)
        service?.reportModel = self.reportModel
        TimeRecord.time?.removeAll()
        TimeRecord.time = nil
        if let dims = TimeRecord.chooseDim {
            for i in 0..<dims.count {
                TimeRecord.chooseDim![i].removeAll()
            }
        }
        TimeRecord.chooseDim?.removeAll()
        TimeRecord.chooseDim = nil
        
        TimeRecord.tagCount = 0
        TimeRecord.startTime = Date()
        headBar.layer.cornerRadius = 4
        headBar.layer.masksToBounds = true
        drawerView?.rx_vcState.asObservable()
            .subscribe(onNext: {[weak self] (changed) in
                guard let self = self else {return}
                self.vcState = changed
        }).disposed(by: dispose)
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationName.kFinishWithCloudServieDB.observe(sender: self, selector: #selector(self.finishWithCloudServiceHandle(_:)))
        if isFirstTime {
            brianView.bgColor = #colorLiteral(red: 0.9490196078, green: 0.9568627451, blue: 0.9843137255, alpha: 1)
            brianView.mainColor = #colorLiteral(red: 0.2941176471, green: 0.3647058824, blue: 0.8, alpha: 1)    //主色调
            brianView.textColor = .black    //文字颜色
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
            brianView.observe(with: leftArray, right: rightArray)//开始观察
            brianView.infoUrlString = "https://docs.myflowtime.cn/%E2%98%81%EF%B8%8F%E5%90%8D%E8%AF%8D%E8%A7%A3%E9%87%8A/%F0%9F%91%BD%E8%84%91%E7%94%B5%E6%B3%A2%EF%BC%88EEG%EF%BC%89.html"
            
            spectrumView.bgColor = #colorLiteral(red: 0.9490196078, green: 0.9568627451, blue: 0.9843137255, alpha: 1)
            spectrumView.mainColor = #colorLiteral(red: 0.2941176471, green: 0.3647058824, blue: 0.8, alpha: 1)
            spectrumView.observe(with: (0.1, 0.28, 0.59, 0.02, 0.1))
            spectrumView.infoUrlString = "https://docs.myflowtime.cn/%E2%98%81%EF%B8%8F%E5%90%8D%E8%AF%8D%E8%A7%A3%E9%87%8A/%F0%9F%94%8B%E8%84%91%E7%94%B5%E6%B3%A2%E9%A2%91%E6%AE%B5%E8%83%BD%E9%87%8F.html"
            
            heartView.bgColor = #colorLiteral(red: 1, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            heartView.mainColor = #colorLiteral(red: 0.8, green: 0.3215686275, blue: 0.4078431373, alpha: 1)
            heartView.textColor = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
            heartView.observe(with: 65)
            heartView.infoUrlString = "https://docs.myflowtime.cn/%E2%98%81%EF%B8%8F%E5%90%8D%E8%AF%8D%E8%A7%A3%E9%87%8A/%E2%9D%A4%EF%B8%8F%E5%BF%83%E7%8E%87.html"
            
            attentionView.bgColor = #colorLiteral(red: 0.7803921569, green: 1, blue: 0.8941176471, alpha: 1)
            attentionView.mainColor = #colorLiteral(red: 0.3725490196, green: 0.7764705882, blue: 0.5843137255, alpha: 1)
            attentionView.observe(with:39)
            attentionView.infoUrlString = "https://docs.myflowtime.cn/%E2%98%81%EF%B8%8F%E5%90%8D%E8%AF%8D%E8%A7%A3%E9%87%8A/%F0%9F%8E%AF%E6%B3%A8%E6%84%8F%E5%8A%9B.html"
            
            relaxationView.bgColor = #colorLiteral(red: 0.8980392157, green: 0.9176470588, blue: 0.968627451, alpha: 1)
            relaxationView.mainColor = #colorLiteral(red: 0.2941176471, green: 0.3647058824, blue: 0.8, alpha: 1)
            relaxationView.observe(with: 69)
            relaxationView.infoUrlString  = "https://docs.myflowtime.cn/%E2%98%81%EF%B8%8F%E5%90%8D%E8%AF%8D%E8%A7%A3%E9%87%8A/%F0%9F%8D%80%E6%94%BE%E6%9D%BE%E5%BA%A6.html"
            
            pressureView.bgColor = #colorLiteral(red: 1, green: 0.9058823529, blue: 0.9019607843, alpha: 1)
            pressureView.mainColor = #colorLiteral(red: 0.8, green: 0.3215686275, blue: 0.4078431373, alpha: 1)
            pressureView.observe()
            pressureView.infoUrlString = "https://docs.myflowtime.cn/%E2%98%81%EF%B8%8F%E5%90%8D%E8%AF%8D%E8%A7%A3%E9%87%8A/%F0%9F%98%A7%E5%8E%8B%E5%8A%9B%E6%B0%B4%E5%B9%B3.html"
            
            brianView.showTip()
            spectrumView.showTip()
            heartView.showTip()
            attentionView.showTip()
            relaxationView.showTip()
            pressureView.showTip()
            isFirstTime = false
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if BLEService.shared.bleManager.state.isConnected  {
            if !RelaxManager.shared.isWebSocketConnected {
                
                RelaxManager.shared.start(wbDelegate: service)
            } 
        }
        BLEService.shared.bleManager.delegate = service
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationName.kFinishWithCloudServieDB.remove(sender: self)
    }
    
    func setUI() {
        startBtn.layer.cornerRadius = 22
        startBtn.layer.masksToBounds = true
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        
        let action = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okBtn = UIAlertAction(title: "确定", style: .default) { (action) in
            self.finishMeditation()
        }
        if let times = service?.meditationModel.startTime,
        Int(Date().timeIntervalSince(times)) > Preference.meditationTime  {
            let alert = UIAlertController(title: "是否结束", message: "结束体验并获取分析报告", preferredStyle: .alert)
            alert.addAction(action)
            alert.addAction(okBtn)
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "是否结束", message: "体验时长不足无法生成报表,确定退出?", preferredStyle: .alert)
            alert.addAction(action)
            alert.addAction(okBtn)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
 
        if let models = ACTagModel.shared.tagModels {
            let currentTag = ACTagModel.shared.currentTag
            if let tags = models[currentTag].tag {
                TimeRecord.tagCount = tags.count
            }
        }
        
        let recordVC = RecordViewController()
        self.navigationController?.pushViewController(recordVC, animated: true)
    }
    
    /// 结束体验
    func finishMeditation()  {
        if RelaxManager.shared.isWebSocketConnected {
            if let times = service?.meditationModel.startTime,
                Int(Date().timeIntervalSince(times)) > Preference.meditationTime  {
                SVProgressHUD.show(withStatus: "正在生成报表")
                service?.finish()
            } else {
                RelaxManager.shared.stopBLE()
                RelaxManager.shared.clearCloudService()
                cleanAll()
                self.navigationController?.dismiss(animated: true, completion: {
                    UIViewController.currentViewController()?.navigationController?.popViewController(animated: false)
                })
            }
        } else {
            if BLEService.shared.bleManager.state.isConnected {
                RelaxManager.shared.stopBLE()
            }
            
            cleanAll()
            self.navigationController?.dismiss(animated: true, completion: {
                SVProgressHUD.show(withStatus: "情感云未连接")
                SVProgressHUD.dismiss(withDelay: 2)
                UIViewController.currentViewController()?.navigationController?.popViewController(animated: false)
            })
        }
    }
    
    func cleanAll() {
        if let dims = TimeRecord.chooseDim {
            for (i,_) in dims.enumerated() {
                if let _ = TimeRecord.chooseDim  {
                    TimeRecord.chooseDim![i].removeAll()
                }
                
            }
            TimeRecord.chooseDim?.removeAll()
            TimeRecord.chooseDim = nil
        }
        
        
        TimeRecord.startTime = nil
         
        TimeRecord.time?.removeAll()
        TimeRecord.time = nil
        TimeRecord.tagCount  = 0
        self.navigationController?.dismiss(animated: true, completion: {
            UIViewController.currentViewController()?.navigationController?.popViewController(animated: false)
        })
    }
    
    /// 情感云结束体验通知处理
    ///
    /// - Parameter notification:
    @objc
    private func finishWithCloudServiceHandle(_ notification: Notification) {
        
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            self.navigationController?.dismiss(animated: true, completion: {
                UIViewController.currentViewController()?.navigationController?.popViewController(animated: false)
            })
            
        }
    }
}
