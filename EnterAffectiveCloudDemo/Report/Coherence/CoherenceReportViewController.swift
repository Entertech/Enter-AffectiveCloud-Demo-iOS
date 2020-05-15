//
//  CoherenceReportViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/5/14.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI

class CoherenceReportViewController: UIViewController {

    @IBOutlet weak var coherenceView: AffectiveChartCoherenceView!
    @IBOutlet weak var aboutView: ReportAboutView!
    var service: ReportService?
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title  = "和谐度"
        aboutView.style = .coherence
        aboutView.icon = .blue
        aboutView.text = "和谐度说明"
        coherenceView.setDataFromModel(hrv: service?.fileModel.coherence)
        if let avg = service?.fileModel.coherenceAvg {
            coherenceView.hrvAvg = avg
        }
        
        self.navigationItem.largeTitleDisplayMode = .never
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
