//
//  ReportViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/16.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI
import EnterAffectiveCloud

enum ReportType: String {
    case heart = "Heart Rate"
    case hrv = "Heart Rate Variability"
    case brainwave = "Brainwave Power Ratio"
    case attention  = "Attention"
    case relaxation = "Relaxation"
    case pressure = "Pressure"
}

class ReportViewController: UIViewController {
    
    public var reportDB: DBMeditation?

    private let service = ReportViewService()
    @IBOutlet weak var reportHeadView: UIView!
    @IBOutlet weak var reportTitle: UILabel!
    @IBOutlet weak var brainView: BrainSpecturmReportView!
    @IBOutlet weak var heartRateView: HeartRateReportView!
    @IBOutlet weak var hrvView: HeartRateVariablityReportView!
    @IBOutlet weak var attentionView: AttentionReportView!
    @IBOutlet weak var relaxationView: RelaxationReportView!
    @IBOutlet weak var pressureView: PressureReportView!
    @IBOutlet weak var reportBackgroud: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        service.show()
    }
    
    func loadData() {
        var path = ""
        var isSample = false
        var reader: EnterAffectiveCloudReportData?
        if let startTime = reportDB?.startTime {
            let meditationDate = Date.date(dateString: startTime, custom: "yyyy-MM-dd HH:mm:ss")
            if let mDate = meditationDate {
                self.reportTitle.text = mDate.string(custom: "M.d.yyyy")
            } else {
                self.reportTitle.text = "0.0.2000"
            }
            
            path = "\(Preference.userID)/42/121/\(startTime)" //42/121/原来为课程位置,后课程不在此引入
            let fileURL = FTFileManager.shared.userReportURL(path)
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: fileURL.path) {
                reader = ReportFileHander.readReportFile(fileURL.path)
                
            } else  {
                path = Bundle.main.path(forResource: "sample", ofType: "report")!
                reader = ReportFileHander.readReportFile(path)
                
                isSample = true
            }
            
        } else {
            path = Bundle.main.path(forResource: "sample", ofType: "report")!
            reader =  ReportFileHander.readReportFile(path)
            isSample = true
        }
        if let reader =  reader {
            service.dataOfReport = reader
            service.braveWaveView = brainView
            service.heartRateView = heartRateView
            service.hrvView = hrvView
            service.attentionView = attentionView
            service.relaxationView = relaxationView
            service.pressureView = pressureView
        }
    }
    
    private func reportPath() -> String {

        if let startTime = self.reportDB?.startTime {
            return "\(Preference.userID)/42/121/\(startTime)"
        }
        return Bundle.main.path(forResource: "sample", ofType: "report")!
    }

    
    @IBAction func editAction(_ sender: Any) {
        let tableVC = ReportViewSortViewController()
        self.navigationController?.pushViewController(tableVC, animated: true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func screenshotAction(_ sender: Any) {
        saveScreenAndShare()
    }
    
    private func setLayout() {
        let boardIndex = dashboardIndex
        let isShowArray = reportShowSwitch
        var viewArray: [UIView] = []
        
        for (index, e) in boardIndex.enumerated() {
            switch e {
            case .heart:
                if isShowArray[index] {
                    viewArray.append(heartRateView)
                    heartRateView.removeAllConstrains()
                    heartRateView.snp.remakeConstraints{
                        $0.left.equalToSuperview().offset(16)
                        $0.right.equalToSuperview().offset(-16)
                        $0.height.equalTo(290)
                    }
                }
                heartRateView.isHidden = !isShowArray[index]
            case .brainwave:
                if isShowArray[index] {
                    viewArray.append(brainView)
                    brainView.removeAllConstrains()
                    brainView.snp.remakeConstraints{
                        $0.left.equalToSuperview().offset(16)
                        $0.right.equalToSuperview().offset(-16)
                        $0.height.equalTo(314)
                    }
                }
                brainView.isHidden = !isShowArray[index]
            case .hrv:
                if isShowArray[index] {
                    viewArray.append(hrvView)
                    hrvView.removeAllConstrains()
                    hrvView.snp.remakeConstraints{
                        $0.left.equalToSuperview().offset(16)
                        $0.right.equalToSuperview().offset(-16)
                        $0.height.equalTo(260)
                    }
                }
                heartRateView.isHidden = !isShowArray[index]
            case .attention:
                if isShowArray[index] {
                    viewArray.append(attentionView)
                    attentionView.removeAllConstrains()
                    attentionView.snp.remakeConstraints{
                        $0.left.equalToSuperview().offset(16)
                        $0.right.equalToSuperview().offset(-16)
                        $0.height.equalTo(300)
                    }
                }
                attentionView.isHidden = !isShowArray[index]
            case .relaxation:
                if isShowArray[index] {
                    viewArray.append(relaxationView)
                    relaxationView.removeAllConstrains()
                    relaxationView.snp.remakeConstraints{
                        $0.left.equalToSuperview().offset(16)
                        $0.right.equalToSuperview().offset(-16)
                        $0.height.equalTo(300)
                    }
                }
                relaxationView.isHidden = !isShowArray[index]
            case .pressure:
                if isShowArray[index] {
                    viewArray.append(pressureView)
                    pressureView.removeAllConstrains()
                    pressureView.snp.remakeConstraints{
                        $0.left.equalToSuperview().offset(16)
                        $0.right.equalToSuperview().offset(-16)
                        $0.height.equalTo(200)
                    }
                }
                pressureView.isHidden = !isShowArray[index]
            }
            
        }
        
        if viewArray.count > 0 {
            
            viewArray[0].snp.makeConstraints {
                $0.top.equalTo(self.reportHeadView.snp.bottom).offset(16)
            }
            
            
            for i in 1..<viewArray.count {
                viewArray[i].snp.makeConstraints{
                    $0.top.equalTo(viewArray[i-1].snp.bottom).offset(16)
                }
            }
            
            viewArray.last!.snp.makeConstraints{
                $0.bottom.equalToSuperview().offset(-60).priority(.high)
            }
        } else {
            self.heartRateView.snp.remakeConstraints{
                $0.bottom.equalToSuperview().offset(self.view.bounds.height-200).priority(.high)
                $0.top.left.right.equalToSuperview()
                $0.height.equalTo(121)
            }
        }
    }
    
    private let defaultDashboardIndex: [ReportType] = [.brainwave, .heart, .hrv, .attention, .relaxation, .pressure]
    private let dashboardIndexKey = "ReportIndex"
    var dashboardIndex: [ReportType] {
        get {
            let value = UserDefaults.standard.array(forKey: dashboardIndexKey) as? [String]
            if value != nil {
                var array: [ReportType] = []
                for e in value! {
                    if e == "Heart" {
                        array.append(.heart)
                    } else if e == "Brainwave" {
                        array.append(.brainwave)
                    } else if e == "HRV" {
                        array.append(.hrv)
                    } else if e == "Attention" {
                        array.append(.attention)
                    } else if e == "Relaxation" {
                        array.append(.relaxation)
                    } else if e == "Pressure" {
                        array.append(.pressure)
                    }
                }
                return array
            } else {
                return defaultDashboardIndex
            }
        }
    }
    
    private let defaultSwitch: [Bool] = Array(repeating: true, count: 6)
    private let switchKey = "SwitchKey"
    var reportShowSwitch: [Bool] {
        get {
            let reader = UserDefaults.standard.array(forKey: switchKey) as? [Bool]
            if let value = reader {
                return value
            }
            return defaultSwitch
        }
        set {
            UserDefaults.standard.set(newValue, forKey: dashboardIndexKey)
        }
    }
    
    ///保存截图并分享
    private func saveScreenAndShare() {
//        let scales = UIScreen.main.scale
//        let shotImage: UIImage?
//        self.scrollBackground.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.9450980392, blue: 0.9176470588, alpha: 1)
//        shotImage = self.scrollBackground.capture
//        var headImage = #imageLiteral(resourceName: "img_share_bg")
//        let headImageView = UIImageView(image: headImage)
//        let nameLabel = UILabel(frame: CGRect(x: 0, y: 68, width: headImageView.frame.width, height: 20))
//        nameLabel.textAlignment = .center
//        nameLabel.text = "\(User.default.name)'s"
//        nameLabel.font = UIFont.systemFont(ofSize: 16)
//        let titleLabel1 = UILabel(frame: CGRect(x: 30, y: 95, width: headImageView.frame.width-60, height: 24))
//        let text1 = "Meditation Biofeedback"
//        titleLabel1.textAlignment = .center
//        titleLabel1.text = text1
//        titleLabel1.font = UIFont.systemFont(ofSize: 24, weight: .bold)
//        let titleLabel2 = UILabel(frame: CGRect(x: 30, y: 120, width: headImageView.frame.width-60, height: 24))
//        let text2 = "Report"
//        titleLabel2.textAlignment = .center
//        titleLabel2.text = text2
//        titleLabel2.font = UIFont.systemFont(ofSize: 24, weight: .bold)
//        let time = UILabel(frame: CGRect(x: 0, y: 160, width: headImageView.frame.width, height: 16))
//        time.textAlignment = .center
//        time.text = timeLabel.text
//        time.font = UIFont.systemFont(ofSize: 14)
//        headImageView.addSubview(nameLabel)
//        headImageView.addSubview(titleLabel1)
//        headImageView.addSubview(titleLabel2)
//        headImageView.addSubview(time)
//        headImage = headImageView.snapshotImageByLayer()!
//
//        let beforeResizeImage = shotImage?.mergeImage(other: headImage) //上下合并图, 不同分辨率屏幕 截出来x2,x3
//        let resizeImage = beforeResizeImage!.resizableImage(withCapInsets: UIEdgeInsets(top: (beforeResizeImage?.size.height)! - 2, left: 0, bottom: (beforeResizeImage?.size.height)! - 1, right: 0), resizingMode: .stretch)
//        let tempImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: resizeImage.size.width, height: resizeImage.size.height+100*scales))
//        tempImageView.image = resizeImage
//
//        let logoImage = #imageLiteral(resourceName: "img_share_icon")
//        let iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: logoImage.size.width*scales, height: logoImage.size.height*scales))
//        iconImageView.image = logoImage
//        tempImageView.addSubview(iconImageView)
//        iconImageView.center = CGPoint(x: tempImageView.frame.width / 2, y: tempImageView.frame.height - 160 - 20*scales)
//        let shareImage = tempImageView.snapshotImageByLayer()!
//        let activitiyViewcontroller = UIActivityViewController(activityItems: [shareImage],
//                                                               applicationActivities: nil)
//        self.present(activitiyViewcontroller, animated: true, completion: nil)
//
//        self.scrollBackground.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.9529411765, blue: 0.9607843137, alpha: 1)
    }
}
