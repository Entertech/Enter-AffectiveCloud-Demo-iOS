//
//  MainReportViewController.swift
//  Flowtime
//
//  Created by Enter on 2019/12/26.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI

class MainReportViewController: UIViewController {


    @IBOutlet weak var topConstraints: NSLayoutConstraint!
    @IBOutlet weak var bg0: UIView!
    @IBOutlet weak var head2: PrivateReportViewHead!
    @IBOutlet weak var view2: PrivateReportBrainwaveSpectrum!
    @IBOutlet weak var head3: PrivateReportViewHead!
    @IBOutlet weak var view3: PrivateReportHRV!
    @IBOutlet weak var head4: PrivateReportViewHead!
    @IBOutlet weak var view4: PrivateReportHR!
    @IBOutlet weak var head5: PrivateReportViewHead!
    @IBOutlet weak var view5: PrivateReportRelaxationAndAttention!
    @IBOutlet weak var head6: PrivateReportViewHead!
    @IBOutlet weak var view6: PrivateReportPressure!
    @IBOutlet weak var head7: PrivateReportViewHead!
    @IBOutlet weak var view7: ReportCoherence!
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var bg2: UIView!
    @IBOutlet weak var bg3: UIView!
    @IBOutlet weak var bg4: UIView!
    @IBOutlet weak var bg5: UIView!
    @IBOutlet weak var bg6: UIView!
    @IBOutlet weak var bg7: UIView!
    
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var bt4: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    var service: ReportService = ReportService()
    var meditationDB: DBMeditation?
    var pViewController: UIViewController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.bg2
        bg.backgroundColor = Colors.bg2
        head2.image = #imageLiteral(resourceName: "icon_report_brain")
        head2.titleText = "脑电波频谱"
        btn2.addTarget(self, action: #selector(showBrain), for: .touchUpInside)
        
        head3.image = #imageLiteral(resourceName: "icon_report_heart")
        head3.titleText = "心率变异性"
        btn3.addTarget(self, action: #selector(showHrv), for: .touchUpInside)
        
        head4.image = #imageLiteral(resourceName: "icon_report_hrv")
        head4.titleText = "心率"
        bt4.addTarget(self, action: #selector(showHr), for: .touchUpInside)
        
        head5.image = #imageLiteral(resourceName: "icon_report_relaxtion")
        head5.titleText = "专注度&放松度"
        btn5.addTarget(self, action: #selector(showAttention), for: .touchUpInside)
        
        head6.image = #imageLiteral(resourceName: "icon_report_stress")
        head6.titleText = "压力值"
        btn6.addTarget(self, action: #selector(showPressure), for: .touchUpInside)
        
        head7.image = #imageLiteral(resourceName: "icon_report_heart")
        head7.titleText = "和谐度"
        btn6.addTarget(self, action: #selector(showPressure), for: .touchUpInside)
        
        setShadow(view: bg2)
        setShadow(view: bg3)
        setShadow(view: bg4)
        setShadow(view: bg5)
        setShadow(view: bg6)
        setShadow(view: bg7)
        service.vc = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        service.meditationDB = meditationDB
    }
    
    public var navigationTitle: String = "" {
        willSet {
            navigationItem.title = newValue
        }
    }
    
    public var isExample: Bool = false {
        willSet {
            if newValue {
                
                topConstraints.constant = 193
            }
        }
    }
    
    private func setShadow(view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 6
    }
    
    @objc private func showBrain() {
        let vc = BrainwaveViewController()
        vc.service = service
        vc.hidesBottomBarWhenPushed = true
        if let p = pViewController {
            p.navigationController?.pushViewController(vc, animated: true)
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc
    private func showHrv() {
        let vc = HRVReportViewController()
        vc.service = service
        vc.hidesBottomBarWhenPushed = true
        if let p = pViewController {
            p.navigationController?.pushViewController(vc, animated: true)
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func showHr() {
        let vc = HRReportViewController()
        vc.service = service
        vc.hidesBottomBarWhenPushed = true
        if let p = pViewController {
            p.navigationController?.pushViewController(vc, animated: true)
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func showAttention() {
        let vc = RAndAViewController()
        vc.service = service
        vc.hidesBottomBarWhenPushed = true
        if let p = pViewController {
            p.navigationController?.pushViewController(vc, animated: true)
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func showPressure() {
        let vc = PressureReportViewController()
        vc.service = service
        vc.hidesBottomBarWhenPushed = true
        if let p = pViewController {
            p.navigationController?.pushViewController(vc, animated: true)
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func showConherence(_ sender: Any) {
        let vc = CoherenceReportViewController()
        vc.service = service
        vc.hidesBottomBarWhenPushed = true
        if let p = pViewController {
            p.navigationController?.pushViewController(vc, animated: true)
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
