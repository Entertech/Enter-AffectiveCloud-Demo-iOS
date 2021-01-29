//
//  HRVReportViewController.swift
//  Flowtime
//
//  Created by Enter on 2020/1/1.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI

class HRVReportViewController: UIViewController {

    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var hrvView: AffectiveChartHRVView!
    @IBOutlet weak var aboutView: ReportAboutView!
    
    var service: ReportService?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title  = lang("心率变异性")
        aboutView.style = .hrv  
        aboutView.icon = .yellow
        aboutView.text = lang("HRV随冥想状态而变化。 在放松状态下，HRV通常较高。 通过长期的冥想练习，HRV的整体水平将提高。")
        hrvView.uploadCycle = UInt(Preference.kCloudServiceUploadCycle)
        hrvView.setDataFromModel(hrv: service?.fileModel.heartRateVariability)
        if let avg = service?.fileModel.hrvAvg {
            hrvView.hrvAvg = avg
        }
        
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.hidesBackButton = false
    }

}
