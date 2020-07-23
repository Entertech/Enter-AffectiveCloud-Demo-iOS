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

    @IBOutlet weak var screenBottom: NSLayoutConstraint!
    @IBOutlet weak var askForStartsView: AskforStartsView!
    @IBOutlet weak var askForStartsHeight: NSLayoutConstraint!
    @IBOutlet weak var bg1top: NSLayoutConstraint!
    @IBOutlet weak var bg0: UIView!
    @IBOutlet weak var bg0Mask: UIView!
    @IBOutlet weak var introductionView: IntroductionView!
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
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var bg1: UIView!
    @IBOutlet weak var bg1Mask: UIView!
    @IBOutlet weak var bg2: UIView!
    @IBOutlet weak var bg3: UIView!
    @IBOutlet weak var bg4: UIView!
    @IBOutlet weak var bg5: UIView!
    @IBOutlet weak var bg6: UIView!
    
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var bt4: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    var service: ReportService?
    override func viewDidLoad() {
        super.viewDidLoad()
        introductionView.header.titleLabel.textColor = .white
        btn1.addTarget(self, action: #selector(showTotal), for: .touchUpInside)
        
        head2.image = #imageLiteral(resourceName: "icon_report_brain")
        head2.titleText = "脑波频谱"
        btn2.addTarget(self, action: #selector(showBrain), for: .touchUpInside)
        view2.bgColor = Colors.bgZ1
        view2.waveText = "波"
        
        head3.image = #imageLiteral(resourceName: "icon_report_heart")
        head3.titleText = "心率变异性"
        btn3.addTarget(self, action: #selector(showHrv), for: .touchUpInside)
        view3.colors = [Colors.yellowPrimary.changeAlpha(to: 0.2),
                        Colors.yellowPrimary.changeAlpha(to: 0.6),
                        Colors.yellowPrimary]
        view3.lineNumColor = Colors.yellow2
        view3.numberView.stateTextColor = Colors.yellow2
        view3.numberView.language = .ch
        
        head4.image = #imageLiteral(resourceName: "icon_report_hrv")
        head4.titleText = "心率"
        bt4.addTarget(self, action: #selector(showHr), for: .touchUpInside)
        view4.colors = [Colors.redPrimary.changeAlpha(to: 0.2),
                        Colors.redPrimary.changeAlpha(to: 0.6),
                        Colors.redPrimary]
        view4.lineNumColor = Colors.red2
        view4.numberView.stateTextColor = Colors.red2
        view4.numberView.language = .ch
        
        head5.image = #imageLiteral(resourceName: "icon_report_relaxtion")
        head5.titleText = "放松度和注意力"
        btn5.addTarget(self, action: #selector(showAttention), for: .touchUpInside)
        view5.relaxationStateColor = Colors.blue5
        view5.attentionStateColor = Colors.green5
        view5.relaxationCircleView.bgColor = Colors.lineLight
        view5.attentionCircleView.bgColor = Colors.lineLight
        view5.line.backgroundColor = Colors.lineLight
        view5.relaxationStateTextColor = Colors.blue2
        view5.attentionStateTextColor = Colors.green2
        view5.relaxationCircleView.text = "放松度"
        view5.attentionCircleView.text = "注意力"
        view5.attentionNumberView.language = .ch
        view5.relaxationNumberView.language = .ch
        
        head6.image = #imageLiteral(resourceName: "icon_report_stress")
        head6.titleText = "压力值"
        btn6.addTarget(self, action: #selector(showPressure), for: .touchUpInside)
        view6.stateColor = Colors.red5
        view6.circleView.bgColor = Colors.lineLight
        view6.stateTextColor = Colors.red2
        view6.language = .ch
        
        self.view.backgroundColor = Colors.bg2
        
        bg0Mask.backgroundColor = Colors.maskLight
        bg1.backgroundColor = Colors.greenPrimary
        bg2.backgroundColor = Colors.bgZ1
        bg3.backgroundColor = Colors.bgZ1
        bg4.backgroundColor = Colors.bgZ1
        bg5.backgroundColor = Colors.bgZ1
        bg6.backgroundColor = Colors.bgZ1
        bg1Mask.backgroundColor = Colors.maskLight
    }
    
    private func setShadow(view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 6
    }
    
    @objc private func showBrain() {
        //Appearance.setRecord("405", "Statistics界面 脑波频谱报表按钮")
        let vc = BrainwaveViewController()
        vc.service = service
        vc.hidesBottomBarWhenPushed = true
        self.view.superview?.paretViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func showTotal() {
        //Appearance.setRecord("410", "Statistics界面 课程详情报表按钮")
        let vc = TotalViewController()
        vc.service = service
        vc.hidesBottomBarWhenPushed = true
        self.view.superview?.paretViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func showHrv() {
        //Appearance.setRecord("406", "Statistics界面 HRV报表按钮")
        let vc = HRVReportViewController()
        vc.service = service
        vc.hidesBottomBarWhenPushed = true
        self.view.superview?.paretViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func showHr() {
        //Appearance.setRecord("407", "Statistics界面 心率报表按钮")
        let vc = HRReportViewController()
        vc.service = service
        vc.hidesBottomBarWhenPushed = true
        self.view.superview?.paretViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func showAttention() {
        //Appearance.setRecord("408", "Statistics界面 放松度和注意力报表按钮")
        let vc = RAndAViewController()
        vc.service = service
        vc.hidesBottomBarWhenPushed = true
        self.view.superview?.paretViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func showPressure() {
        //Appearance.setRecord("409", "Statistics界面 压力报表按钮")
        let vc = PressureReportViewController()
        vc.service = service
        vc.hidesBottomBarWhenPushed = true
        self.view.superview?.paretViewController()?.navigationController?.pushViewController(vc, animated: true)
    }

}
