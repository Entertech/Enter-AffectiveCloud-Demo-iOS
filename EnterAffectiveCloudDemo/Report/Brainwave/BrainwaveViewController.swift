//
//  BrainwaveViewController.swift
//  Flowtime
//
//  Created by Enter on 2019/12/31.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI
import Lottie

class BrainwaveViewController: UIViewController {

    
    @IBOutlet weak var headBg: UIView!
    @IBOutlet weak var bg1: UIView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var brainView: AffectiveChartBrainSpectrumView!
    @IBOutlet weak var aboutView: ReportAboutView!
    private let backBtn = UIButton()
    private let screenShotBtn = UIButton()
    private let animationView = AnimationView()
    var service: ReportService?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.bg2
        bg1.backgroundColor = Colors.bgZ1
        headBg.backgroundColor = Colors.bgZ1
        navigationView.backgroundColor = Colors.bgZ1
        navigationItem.title  = "脑电波频谱"
        brainView.title = "在冥想中的变化"
        aboutView.icon = .blue
        aboutView.text = "脑电波各频率比的变化反映了冥想时精神状态的变化。"
        aboutView.style = .brain
        if let alpha = service?.fileModel.alphaArray,  let beta = service?.fileModel.betaArray, let theta = service?.fileModel.thetaArray, let delta = service?.fileModel.deltaArray, let gama = service?.fileModel.gamaArray {
            brainView.setDataFromModel(gama: gama, delta: delta, theta: theta, alpha: alpha, beta: beta)
        }
        brainView.xLabelText = "时间(分钟)"
        brainView.bgColor = Colors.bgZ1
        brainView.textColor = Colors.textLv1
        brainView.markerBackgroundColor = Colors.bgZ2
        brainView.highlightLineColor = Colors.lineLight
        self.navigationItem.largeTitleDisplayMode = .never
        
        navigationView.addSubview(backBtn)
        navigationView.addSubview(screenShotBtn)
        let title = UILabel()
        navigationView.addSubview(title)
        title.text = "脑电波频谱"
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
        navigationController?.setNavigationBarHidden(true, animated: false)
        //navigationController?.delegate = self
    }
    
    //显示分享条件
    private func shareCondition() {
//        var play = true
//        #if DEBUG
//        play = false
//        #else
//        play = false
//
//        #endif
//        if let service = service, play {
//            let status = Preference.getShareStatus(id: service.recordId)
//            if status >> 2 & 1 == 0 {
//                Preference.setShareStatus(id: service.recordId, status: status | 4)
//                self.navigationView.addSubview(animationView)
//
//                animationView.animation = Animation.named("share")
//                animationView.contentMode = .scaleAspectFit
//                animationView.loopMode = .repeat(2)
//                animationView.shouldRasterizeWhenIdle = true
//                animationView.play()
//                animationView.snp.makeConstraints {
//                    $0.width.height.equalTo(64)
//                    $0.center.equalTo(screenShotBtn.snp.center)
//                }
//                screenShotBtn.isHidden = true
//
//                let stopAnimationBtn = UIButton()
//                self.navigationView.addSubview(stopAnimationBtn)
//                stopAnimationBtn.setTitle("", for: .normal)
//                stopAnimationBtn.backgroundColor = .clear
//                stopAnimationBtn.addTarget(self, action: #selector(stopAnimation(_:)), for: .touchUpInside)
//                stopAnimationBtn.snp.makeConstraints {
//                    $0.height.width.equalTo(44)
//                    $0.center.equalTo(screenShotBtn.snp.center)
//                }
//
//                let shareIV = UIImageView(image: #imageLiteral(resourceName: "img_share_progress"))
//                self.view.addSubview(shareIV)
//                shareIV.snp.makeConstraints {
//                    $0.top.equalTo(self.navigationView.snp.bottom).offset(-18)
//                    $0.right.equalToSuperview().offset(-6)
//                    $0.width.equalTo(175)
//                    $0.height.equalTo(87)
//                }
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
//                    self.screenShotBtn.isHidden = false
//                    shareIV.removeFromSuperview()
//                    self.animationView.removeFromSuperview()
//                    stopAnimationBtn.removeFromSuperview()
//                }
//            }
//        }
        
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
        view.saveScreenAndShare(timeString: timeString)
       
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
