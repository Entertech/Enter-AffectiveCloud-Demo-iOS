//
//  HRVReportViewController.swift
//  Flowtime
//
//  Created by Enter on 2020/1/1.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI
import Lottie
import SafariServices

class PressureReportViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var vbg2: UIView!

    @IBOutlet weak var bg1: UIView!
    @IBOutlet weak var headBg: UIView!
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var pressureView: AffectiveChartPressureView!
    @IBOutlet weak var avgView: PrivateAverageView!
    @IBOutlet weak var avgHeader: PrivateReportViewHead!
    @IBOutlet weak var aboutView: ReportAboutView!
    private let backBtn = UIButton()
    private let screenShotBtn = UIButton()
    private let animationView = AnimationView()
    var service: ReportService?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.bg2
        headBg.backgroundColor = Colors.bgZ1
        bg.backgroundColor = Colors.bg2
        scrollView.backgroundColor = Colors.bg2
        bg1.backgroundColor = Colors.bgZ1
        vbg2.backgroundColor = Colors.bgZ1
        avgHeader.backgroundColor = .clear
        avgView.backgroundColor = .clear
        avgView.textBgColor = Colors.bgZ2
        pressureView.textColor = Colors.textLv1
        pressureView.bgColor = Colors.bgZ1
        pressureView.markerBackgroundColor = Colors.bgZ2
        pressureView.highlightLineColor = Colors.lineLight
        navigationView.backgroundColor = Colors.bgZ1
        
        navigationItem.title  = "压力值"
        pressureView.title = "在冥想中的变化"
        aboutView.style = .pressure
        aboutView.icon = .red
        aboutView.text = "深呼吸训练可以有效地减轻压力，长期冥想训练可以提高压力的适应能力。 压力和松弛图在物理和生理水平上反映您的松弛状态。"
        pressureView.setDataFromModel(pressure: service?.fileModel.pressure)
        if let avg = service?.fileModel.pressureAvg {
            pressureView.pressureAvg = avg
        }
        avgView.language = .ch
        avgView.numBgColor = Colors.red5
        avgView.numTextColor = Colors.red2
        avgView.categoryName = .Pressure
        avgView.barColor = Colors.lineLight
        avgView.unitText = "bpm"
        avgView.averageText = "平均值"
        avgView.mainColor = Colors.redPrimary
        if let values = service?.listModel.last7Pressure {
            avgView.values = values
        }

        avgHeader.image = #imageLiteral(resourceName: "icon_statistics_red")
        avgHeader.titleText = "过去7次"
        avgHeader.btnImage = UIImage(named: "icon_infoCircle")
        avgHeader.barButton.addTarget(self, action: #selector(showWeb), for: .touchUpInside)
        
        navigationView.addSubview(backBtn)
        navigationView.addSubview(screenShotBtn)
        let title = UILabel()
        navigationView.addSubview(title)
        title.text = "压力值"
        title.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        title.textColor = Colors.textLv1
        title.snp.makeConstraints {
            $0.center.equalToSuperview()

        }
        backBtn.setImage(#imageLiteral(resourceName: "icon_back_color"), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.height.width.equalTo(44)
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview()
        }
        screenShotBtn.setImage(#imageLiteral(resourceName: "icon_share"), for: .normal)
        screenShotBtn.addTarget(self, action: #selector(screenShotAction), for: .touchUpInside)
        screenShotBtn.snp.makeConstraints {
            $0.height.width.equalTo(44)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.delegate = self
        self.navigationItem.largeTitleDisplayMode = .never
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.hidesBackButton = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shareCondition()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    /// 显示分享
    private func shareCondition() {
        var pass = false
        if let service = service {
            if let hrv = service.fileModel.pressure {
                var zeroCount = 0
                for e in hrv {
                    if e == 0 {
                        zeroCount += 1
                    }
                }
                if Float(zeroCount) / Float(hrv.count) < (1 - 0.8) {
                    pass = true
                }
            }
            
            if pass {
                pass = false
                if service.listModel.last7Pressure.count > 1 {
                    let array = service.listModel.last7Pressure
                    let total = array.reduce(0, +)
                    let averageValue = CGFloat(total) / CGFloat(array.count)
                    if array[0] < array[1] && array[0] < Int(averageValue) {
                        pass = true
                    }
                }
            }
            
            if pass {
                pass = false
                if let avg = service.fileModel.pressureAvg {
                    if avg < 40 {
                        pass = true
                    }
                }
            }
        }
        
        var play = true
        #if DEBUG
        play = true
        #else
        play = pass
        
        #endif
        if let service = service, play {
            let status = Preference.getShareStatus(id: service.recordId)
            if status >> 5 & 1 == 0 {
                Preference.setShareStatus(id: service.recordId, status: status | 32)
                self.navigationView.addSubview(animationView)
                
                animationView.animation = Animation.named("share")
                animationView.contentMode = .scaleAspectFit
                animationView.loopMode = .repeat(2)
                animationView.shouldRasterizeWhenIdle = true
                animationView.play()
                animationView.snp.makeConstraints {
                    $0.width.height.equalTo(64)
                    $0.center.equalTo(screenShotBtn.snp.center)
                }
                screenShotBtn.isHidden = true
                
                let stopAnimationBtn = UIButton()
                self.navigationView.addSubview(stopAnimationBtn)
                stopAnimationBtn.setTitle("", for: .normal)
                stopAnimationBtn.backgroundColor = .clear
                stopAnimationBtn.addTarget(self, action: #selector(stopAnimation(_:)), for: .touchUpInside)
                stopAnimationBtn.snp.makeConstraints {
                    $0.height.width.equalTo(44)
                    $0.center.equalTo(screenShotBtn.snp.center)
                }
                
                let shareIV = UIImageView(image: #imageLiteral(resourceName: "img_share_progress"))
                self.view.addSubview(shareIV)
                shareIV.snp.makeConstraints {
                    $0.top.equalTo(self.navigationView.snp.bottom).offset(-18)
                    $0.right.equalToSuperview().offset(-6)
                    $0.width.equalTo(175)
                    $0.height.equalTo(87)
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
                    self.screenShotBtn.isHidden = false
                    shareIV.removeFromSuperview()
                    self.animationView.removeFromSuperview()
                    stopAnimationBtn.removeFromSuperview()
                }
            }
        }
    }

    @objc
    private func screenShotAction() {
        screenShotBtn.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            self.screenShotBtn.isEnabled = true
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M.d.yyyy"
        let timeString =  dateFormatter.string(from: service!.meditationTime)
        bg.saveScreenAndShare(timeString: timeString)
       
    }
    
    @objc
    func showWeb() {
        //self.presentSafari(key: .last7Times,  FTRemoteConfigKeyDefaultValue.last7times)
        if let url = FTRemoteConfig.shared.getConfig(key: .last7Times) {
            let sf = SFSafariViewController(url: URL(string: url)!)
            self.present(sf, animated: true, completion: nil)
        }
    }
    
    @objc
    private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func stopAnimation(_ sender: UIButton) {
        screenShotBtn.isHidden = false
        animationView.stop()
        animationView.removeFromSuperview()
        screenShotAction()
        sender.removeFromSuperview()
    }
    
}
