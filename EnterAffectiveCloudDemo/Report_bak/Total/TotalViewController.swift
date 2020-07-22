//
//  TotalViewController.swift
//  Flowtime
//
//  Created by Enter on 2019/12/31.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import EnterAffectiveCloudUI
import Networking
import SVProgressHUD
import RxSwift

class TotalViewController: UIViewController {

    @IBOutlet weak var bt3: UIButton!
    @IBOutlet weak var bt2: UIButton!
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var bg1: UIView!
    @IBOutlet weak var head1: PrivateReportViewHead!
    @IBOutlet weak var view1: PrivateAverageView!
    @IBOutlet weak var bg2: UIView!
    @IBOutlet weak var head2: PrivateReportViewHead!
    @IBOutlet weak var view2: StatisticsReport!
    @IBOutlet weak var bg3: UIView!
    @IBOutlet weak var head3: PrivateReportViewHead!
    @IBOutlet weak var view3: CourseReport!
    private let disposeBag = DisposeBag()
    public var service: ReportService? {
        willSet {
            if let service = newValue {
                if let _ = view1 {
                    view1.values = service.listModel.last7meditation
                    view2.count = service.totalTime
                    view2.number = service.recordList.count - service.dataIndex
                    view3.course = (service.courseName, "")
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "M.d.yyyy"
                    self.navigationItem.title =  dateFormatter.string(from: service.meditationTime)
                }
             }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        setShadow(view: bg1)
        setShadow(view: bg2)
        setShadow(view: bg3)
        head1.image = #imageLiteral(resourceName: "icon_statistics")
        head1.titleText = "Meditation Time"
        head1.btnImage = UIImage(named: "icon_infoCircle")
        head1.barButton.addTarget(self, action: #selector(showWeb), for: .touchUpInside)
        
        head2.image = #imageLiteral(resourceName: "icon_report_streak")
        head2.titleText = "Statistics"
        bt2.addTarget(self, action: #selector(showStatistics), for: .touchUpInside)
        
        head3.image = #imageLiteral(resourceName: "icon_tab_lib_selected")
        head3.titleText = "Course"
        bt3.addTarget(self, action: #selector(showCourse), for: .touchUpInside)
        
        view1.mainColor = UIColor.colorWithHexString(hexColor: "#4B5DCC")
        view1.unitText = "mins"
        view1.categoryName = .Meditation
        
        let item = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_share").withRenderingMode(.alwaysOriginal), style:
            .plain, target: self, action: #selector(screenShotAction))
        
        navigationItem.rightBarButtonItem = item

        
        if let service = service {
            view1.values = service.listModel.last7meditation
            view2.count = service.totalTime
            view2.number = service.recordList.count - service.dataIndex
            view3.course = (service.courseName, "")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M.d.yyyy"
            self.navigationItem.title =  dateFormatter.string(from: service.meditationTime)
            
        }
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    private func setShadow(view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 6
    }
    
    @objc
    func showWeb() {
        
    }
    
    @objc
    func showStatistics() {
        let vc = Streak2ViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.service = self.service
        if let _ = self.navigationController {
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            self.view.superview?.paretViewController()?.navigationController?.pushViewController(vc, animated: true)
        }

        
    }
    
    @objc
    func showCourse() {

        let courseName = service!.courseName
        let userCourse = Preference.localCoursesList.filter{ $0.name == courseName }
        if let course = userCourse.first  {
            let controller = LessonsViewController()
            controller.course = course
            controller.hidesBottomBarWhenPushed = true
            controller.modalPresentationStyle = .fullScreen
            
            if let _ = self.navigationController {
                self.navigationController?.pushViewController(controller, animated: true)
                
            } else {
                self.view.superview?.paretViewController()?.navigationController?.pushViewController(controller, animated: true)
            }

            
        }

    }
    
    @objc
    private func screenShotAction() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M.d.yyyy"
        let timeString =  dateFormatter.string(from: service!.meditationTime)
        bg.saveScreenAndShare(timeString: timeString)
       
    }
}
