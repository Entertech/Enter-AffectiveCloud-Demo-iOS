//
//  HRVReportViewController.swift
//  Flowtime
//
//  Created by Enter on 2020/1/1.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI
import SafariServices
import Lottie

class HRVReportViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bg1: UIView!
    @IBOutlet weak var headBg: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var vbg2: UIView!
    @IBOutlet weak var hrvView: AffectiveChartHRVView!
    @IBOutlet weak var avgView: PrivateAverageView!
    @IBOutlet weak var avgHeader: PrivateReportViewHead!
    @IBOutlet weak var aboutView: ReportAboutView!
    private let backBtn = UIButton()
    private let screenShotBtn = UIButton()
    private let animationView = AnimationView()
    
    var service: ReportService?
    override func viewDidLoad() {
        super.viewDidLoad()
        headBg.backgroundColor = Colors.bgZ1
        navigationView.backgroundColor = Colors.bgZ1
        bg.backgroundColor = Colors.bg2
        scrollView.backgroundColor = Colors.bg2
        bg1.backgroundColor = Colors.bgZ1
        vbg2.backgroundColor = Colors.bgZ1
        self.view.backgroundColor = Colors.bg2
        navigationItem.title = "HRV"
        hrvView.title = "在冥想中的变化"
        aboutView.style = .hrv  
        aboutView.icon = .yellow
        aboutView.text = "HRV 随冥想状态而变化。 在放松状态下，HRV通常较高。 通过长期的冥想练习，HRV的整体水平将提高。"
        hrvView.bgColor = Colors.bgZ1
        hrvView.averageText = "平均值"
        hrvView.xLabelText = "时间(分钟)"
        hrvView.textColor = Colors.textLv1
        hrvView.markerBackgroundColor = Colors.bgZ2
        hrvView.highlightLineColor = Colors.lineLight
        hrvView.setDataFromModel(hrv: service?.fileModel.heartRateVariability)
        if let avg = service?.fileModel.hrvAvg {
            hrvView.hrvAvg = avg
        }
        avgView.lastSevenTime = "过去7次"
        avgView.language = .ch
        avgView.averageText = "平均值"
        avgView.numBgColor = Colors.yellow5
        avgView.numTextColor = Colors.yellow2
        avgView.categoryName = .HRV
        avgView.unitText = "ms"
        avgView.mainColor = Colors.yellowPrimary
        avgView.barColor = Colors.lineLight
        if let values = service?.listModel.last7HRV {
            avgView.values = values
        }
        avgView.backgroundColor = Colors.bgZ1
        avgView.textBgColor = Colors.bgZ2
        
        avgHeader.image = #imageLiteral(resourceName: "icon_record_meditation_flag")
        avgHeader.titleText = "过去7次"
        avgHeader.btnImage = UIImage(named: "icon_infoCircle")
        avgHeader.barButton.addTarget(self, action: #selector(showWeb), for: .touchUpInside)
        avgHeader.backgroundColor = Colors.bgZ1
        
        self.navigationItem.largeTitleDisplayMode = .never
        
        navigationView.addSubview(backBtn)
        navigationView.addSubview(screenShotBtn)
        let title = UILabel()
        navigationView.addSubview(title)
        title.text = "HRV"
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
        self.navigationItem.largeTitleDisplayMode = .never
        //navigationController?.delegate = self
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.hidesBackButton = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shareCondition()
    }
    
    private func shareCondition() {
        var pass = false
        if let service = service {
            if let hrv = service.fileModel.heartRateVariability {
                var zeroCount = 0
                for e in hrv {
                    if e == 0 {
                        zeroCount += 1
                    }
                }
                if Float(zeroCount) / Float(hrv.count) < (1.0 - 0.8) {
                    pass = true
                }
            }
            
            if pass {
                pass = false
                if service.listModel.last7HRV.count > 1 {
                    let array = service.listModel.last7HRV
                    let total = array.reduce(0, +)
                    let averageValue = CGFloat(total) / CGFloat(array.count)
                    if array[0] > array[1] && array[0] > Int(averageValue) {
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
            if status >> 3 & 1 == 0 {
                Preference.setShareStatus(id: service.recordId, status: status | 8)
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
    
    //MARK: - Action

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
