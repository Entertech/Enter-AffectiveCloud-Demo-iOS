//
//  R&AViewController.swift
//  Flowtime
//
//  Created by Enter on 2020/1/1.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI

class RAndAViewController: UIViewController {

    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var chartView: PrivateReportChartAttentionAndRelaxation!
    @IBOutlet weak var aboutView: ReportAboutView!
    var service: ReportService?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = lang("专注度&放松度")
        aboutView.style = .relaxation
        aboutView.icon = .blue
        aboutView.text = lang("如果您没有长期的冥想训练，则您在特定大脑状态下的脑电波会集中。 当您聚焦时，“放松”值通常较低，而当您放松时，“关注”值较低。 注意和放松是互斥的。\n\n经过长期的冥想练习，脑电波的传播范围更加广泛甚至均匀。 您可以同时获得高分的注意力和放松度，从而放松身心并集中精力。 在这种状态下，更容易获得灵感和创造力。")
        
        chartView.setDataFromModel(array: service?.fileModel.attention, state: .attention)
        chartView.setDataFromModel(array: service?.fileModel.relaxation, state: .relaxation)
        if let att = service?.fileModel.attentionAvg, let re = service?.fileModel.relaxationAvg  {
            chartView.attentionAvg = att
            chartView.relaxationAvg = re
        }

        self.navigationItem.largeTitleDisplayMode = .never
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.hidesBackButton = false
    }

}
