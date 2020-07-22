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
        aboutView.text = "研究表明，情绪与心率变化的模式有关。积极的情绪可以提高自主神经系统（ANS）两个分支之间的协调性，增加不同生理系统之间的共振，达到“心脑同步”的和谐状态。这种状态与专注力、快速反应、记忆力和情绪稳定性的提高有关。"
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
