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

class HRReportViewController: UIViewController {

    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var vbg2: UIView!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bg1: UIView!
    @IBOutlet weak var hrView: AffectiveChartHeartRateView!
    @IBOutlet weak var avgView: PrivateAverageView!
    @IBOutlet weak var avgHeader: PrivateReportViewHead!
    @IBOutlet weak var aboutView: ReportAboutView!
    
    var service: ReportService?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.bg2
        bg.backgroundColor = Colors.bg2
        scrollView.backgroundColor = Colors.bg2
        bg1.backgroundColor = Colors.bgZ1
        vbg2.backgroundColor = Colors.bgZ1
        avgHeader.backgroundColor = .clear
        avgView.backgroundColor = .clear
        avgView.textBgColor = Colors.bgZ2

        hrView.averageText = "平均值"
        hrView.xLabelText = "时间(分钟)"
        hrView.textColor = Colors.textLv1
        hrView.bgColor = Colors.bgZ1
        hrView.markerBackgroundColor = Colors.bgZ2
        hrView.highlightLineColor = Colors.lineLight
        navigationItem.title  = "心率"
        hrView.title = "在冥想中的变化"
        aboutView.style = .hr
        aboutView.icon = .red
        aboutView.text = "通常，心率的变化是无序的。 通过长期训练，可以在冥想过程中以一定的周期性节律看到心率。 此时，呼吸和心跳达到协调状态。"
        hrView.setDataFromModel(hr: service?.fileModel.heartRate)
        if let avg = service?.fileModel.heartRateAvg {
            hrView.hrAvg = avg
        }
        avgView.lastSevenTime = "过去7次"
        avgView.language = .ch
        avgView.numBgColor = Colors.red5
        avgView.numTextColor = Colors.red2
        avgView.categoryName = .Heart
        avgView.unitText = "bpm"
        avgView.averageText = "平均值"
        avgView.barColor = Colors.lineLight
        avgView.mainColor = Colors.redPrimary
        if let values = service?.listModel.last7HR {
            avgView.values = values
        }

        avgHeader.image = #imageLiteral(resourceName: "icon_statistics_red")
        avgHeader.titleText = "过去7次"
        avgHeader.btnImage = UIImage(named: "icon_infoCircle")
        avgHeader.barButton.addTarget(self, action: #selector(showWeb), for: .touchUpInside)
        
        let item = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_share").withRenderingMode(.alwaysOriginal), style:
            .plain, target: self, action: #selector(screenShotAction))
        
        navigationItem.rightBarButtonItem = item
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
        //navigationController?.delegate = self
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.hidesBackButton = false
    }

    @objc
    private func screenShotAction() {
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
    
}
