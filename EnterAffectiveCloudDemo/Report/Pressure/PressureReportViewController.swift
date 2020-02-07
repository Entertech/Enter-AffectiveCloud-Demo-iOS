//
//  HRVReportViewController.swift
//  Flowtime
//
//  Created by Enter on 2020/1/1.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI

class PressureReportViewController: UIViewController {

    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var pressureView: PrivateReportChartPressure!
    @IBOutlet weak var aboutView: ReportAboutView!
    
    var service: ReportService?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title  = "压力值"
        aboutView.style = .pressure
        aboutView.icon = .red
        aboutView.text = "深呼吸训练可以有效地减轻压力，长期冥想训练可以提高压力的适应能力。\n\n压力和松弛图在物理和生理水平上反映您的松弛状态。"
        pressureView.setDataFromModel(pressure: service?.fileModel.pressure)
        if let avg = service?.fileModel.pressureAvg {
            pressureView.pressureAvg = avg
        }
        
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.hidesBackButton = false
    }

}
