//
//  HRVReportViewController.swift
//  Flowtime
//
//  Created by Enter on 2020/1/1.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI

class HRReportViewController: UIViewController {

    @IBOutlet weak var bg: UIView!

    @IBOutlet weak var hrView: PrivateReportChartHR!
    @IBOutlet weak var aboutView: ReportAboutView!
    
    var service: ReportService?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title  = "心率"
        aboutView.style = .hr
        aboutView.icon = .red
        aboutView.text = "通常，心率的变化是无序的。 通过长期训练，可以在冥想过程中以一定的周期性节律看到心率。 此时，呼吸和心跳达到协调状态。"
        hrView.setDataFromModel(hr: service?.fileModel.heartRate)
        if let avg = service?.fileModel.heartRateAvg {
            hrView.hrAvg = avg
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.hidesBackButton = false
    }


}
