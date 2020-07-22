//
//  R&AViewController.swift
//  Flowtime
//
//  Created by Enter on 2020/1/1.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI
import Lottie
import SafariServices

class RAndAViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headBg: UIView!
    @IBOutlet weak var bg1: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var pAvgView: PrivateAverageView!
    @IBOutlet weak var aAvgView: PrivateAverageView!
    @IBOutlet weak var chartView: PrivateReportChartAttentionAndRelaxation!
    @IBOutlet weak var bg2: UIView!
    @IBOutlet weak var aHeader: PrivateReportViewHead!
    @IBOutlet weak var bg3: UIView!
    @IBOutlet weak var rHeader: PrivateReportViewHead!
    @IBOutlet weak var aboutView: ReportAboutView!
    private let backBtn = UIButton()
    private let screenShotBtn = UIButton()
    private let animationView = AnimationView()
    var service: ReportService?
    override func viewDidLoad() {
        super.viewDidLoad()
        headBg.backgroundColor = Colors.bgZ1
        navigationView.backgroundColor = Colors.bgZ1
        self.view.backgroundColor = Colors.bg2
        bg.backgroundColor = Colors.bg2
        scrollView.backgroundColor = Colors.bg2
        bg1.backgroundColor = Colors.bgZ1
        bg2.backgroundColor = Colors.bgZ1
        bg3.backgroundColor = Colors.bgZ1
        
        
        aHeader.backgroundColor = .clear
        aAvgView.backgroundColor = .clear
        aAvgView.barColor = Colors.lineLight
        pAvgView.backgroundColor = .clear
        pAvgView.barColor = Colors.lineLight
        rHeader.backgroundColor = .clear
        aAvgView.textBgColor = Colors.bgZ2
        pAvgView.textBgColor = Colors.bgZ2
        chartView.textColor = Colors.textLv1
        chartView.bgColor = Colors.bgZ1
        
        navigationItem.title = "放松度和注意力"
        
        aboutView.style = .relaxation
        aboutView.icon = .blue
        aboutView.text = "如果您没有长期的冥想训练，则您在特定大脑状态下的脑电波会集中。 当您聚焦时，“放松”值通常较低，而当您放松时，“关注”值较低。 注意和放松是互斥的。\n\n 经过长期的冥想练习，脑电波的传播范围更加广泛甚至均匀。 您可以同时获得高分的注意力和放松度，从而放松身心并集中精力。 在这种状态下，更容易获得灵感和创造力。"
        chartView.averageText = "平均值"
        chartView.xLabelText = "时间(分钟)"
        chartView.attentionLabelText = "注意力"
        chartView.relaxationLabelText = "放松度"
        chartView.title = "在冥想中的变化"
        chartView.markerBackgroundColor = Colors.bgZ2
        chartView.highlightLineColor = Colors.lineLight
        chartView.setDataFromModel(array: service?.fileModel.relaxation, state: .relaxation)
        chartView.setDataFromModel(array: service?.fileModel.attention, state: .attention)

        if let att = service?.fileModel.attentionAvg, let re = service?.fileModel.relaxationAvg  {
            chartView.attentionAvg = att
            chartView.relaxationAvg = re
        }
        aAvgView.language = .ch
        aAvgView.averageText = "平均值"
        aAvgView.lastSevenTime = "过去7次"
        aAvgView.numBgColor = Colors.green5
        aAvgView.numTextColor = Colors.green2
        aAvgView.categoryName = .Attention
        aAvgView.unitText =  ""
        aAvgView.mainColor =  Colors.greenPrimary
        if let attAvg = service?.listModel.last7Attention {
            aAvgView.values = attAvg
        }
        
        pAvgView.language = .ch
        pAvgView.averageText = "平均值"
        pAvgView.lastSevenTime = "过去7次"
        pAvgView.numBgColor = Colors.blue5
        pAvgView.numTextColor = Colors.blue2
        pAvgView.categoryName = .Relaxation
        pAvgView.unitText = ""
        pAvgView.mainColor = Colors.bluePrimary
        if let reAvg = service?.listModel.last7Relaxation {
            pAvgView.values = reAvg
        }
        
        aHeader.image = #imageLiteral(resourceName: "icon_statistics_green")
        aHeader.titleText = "过去7次(注意力)"
        aHeader.btnImage = UIImage(named: "icon_infoCircle")
        aHeader.barButton.addTarget(self, action: #selector(showWeb), for: .touchUpInside)
        rHeader.image = #imageLiteral(resourceName: "icon_statistics_blue")
        rHeader.btnImage = UIImage(named: "icon_infoCircle")
        rHeader.titleText = "过去7次(放松度)"

        
        
        navigationView.addSubview(backBtn)
        navigationView.addSubview(screenShotBtn)
        let title = UILabel()
        navigationView.addSubview(title)
        title.text = "放松度与注意力"
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
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.hidesBackButton = false
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shareCondition()
    }
    
    private func shareCondition() {
        var pass = false
        if let service = service {
            if let attention = service.fileModel.attention {
                var zeroCount = 0
                for e in attention {
                    if e == 0 {
                        zeroCount += 1
                    }
                }
                if Float(zeroCount) / Float(attention.count) < (1.0 - 0.8){
                    pass = true
                } else {
                    pass = false
                }
            }
            if pass {
                pass = false
                if let aAvg = service.fileModel.attentionAvg, let rAvg = service.fileModel.relaxationAvg {
                    if aAvg > 70 && rAvg > 70 {
                        pass = true
                    }
                }
            }
            
            if pass {
                pass = false
                if service.listModel.last7Attention.count > 1 {
                    let array = service.listModel.last7Attention
                    let total = array.reduce(0, +)
                    let averageValue = CGFloat(total) / CGFloat(array.count)
                    if array[0] > array[1] && array[0] > Int(averageValue) {
                        pass = true
                    }
                }
            }
            if pass {
                pass = false
                if service.listModel.last7Relaxation.count > 1 {
                    let array = service.listModel.last7Relaxation
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
            if status >> 4 & 1 == 0 {
                Preference.setShareStatus(id: service.recordId, status: status | 16)
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
