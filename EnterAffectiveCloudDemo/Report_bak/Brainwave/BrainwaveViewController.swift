//
//  BrainwaveViewController.swift
//  Flowtime
//
//  Created by Enter on 2019/12/31.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI

class BrainwaveViewController: UIViewController {

    
    @IBOutlet weak var brainView: AffectiveChartBrainSpectrumView!
    @IBOutlet weak var aboutView: ReportAboutView!
    
    var service: ReportService?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title  = "脑电波频谱"
        aboutView.icon = .blue
        aboutView.text = "脑电波各频率比的变化反映了冥想时精神状态的变化。"
        aboutView.style = .brain
        if let alpha = service?.fileModel.alphaArray,  let beta = service?.fileModel.betaArray, let theta = service?.fileModel.thetaArray, let delta = service?.fileModel.deltaArray, let gama = service?.fileModel.gamaArray {
            brainView.setDataFromModel(gama: gama, delta: delta, theta: theta, alpha: alpha, beta: beta)
        }

        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    


}
