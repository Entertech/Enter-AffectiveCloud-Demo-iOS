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
import SafariServices
import Lottie

class TotalViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewTopLayout: NSLayoutConstraint!
    @IBOutlet weak var navigationBg: UIView!
    @IBOutlet weak var navigationView: UIView!
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
    private let backBtn = UIButton()
    private let screenShotBtn = UIButton()
    private let animationView = AnimationView()
    let titleLabel = UILabel()
    public var service: ReportService? {
        willSet {
            if let service = newValue {
                if let _ = view1 {
                    
                    view1.values = service.listModel.last7meditation
                    view2.count = service.totalTime
                    view2.number = service.recordList.count - service.dataIndex
                    //view3.course = (service.courseName, "")
                    if service.courseName == "UNGUIDED" || service.courseName == "unguide" {
                        self.head3.barButton.isHidden = true
                    } else {
                        self.head3.barButton.isHidden = false
                    }
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "M.d.yyyy"
                    self.navigationItem.title =  dateFormatter.string(from: service.meditationTime)
                    titleLabel.text = dateFormatter.string(from: service.meditationTime)
                }
             }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.bg2
        bg.backgroundColor = Colors.bg2
        scrollView.backgroundColor = Colors.bg2
        navigationBg.backgroundColor = Colors.bgZ1
        navigationView.backgroundColor = Colors.bgZ1
        self.navigationItem.largeTitleDisplayMode = .never
        head1.image = #imageLiteral(resourceName: "icon_statistics")
        head1.titleText = "训练时间"
        head1.btnImage = UIImage(named: "icon_infoCircle")
        head1.barButton.addTarget(self, action: #selector(showWeb), for: .touchUpInside)
        head1.backgroundColor = Colors.bgZ1
        
        head2.image = #imageLiteral(resourceName: "icon_report_streak")
        head2.titleText = "统计"
        bt2.addTarget(self, action: #selector(showStatistics), for: .touchUpInside)
        head2.backgroundColor = Colors.bgZ1
        
//        head3.image = #imageLiteral(resourceName: "icon_tab_lib_selected")
//        head3.titleText = "Course"
//        head3.backgroundColor = Colors.bgZ1
//        bt3.addTarget(self, action: #selector(showCourse), for: .touchUpInside)
        view1.language = .ch
        view1.lastSevenTime = "过去7次"
        view1.averageText = "平均值"
        view1.unitText = "分钟"
        view1.mainColor = Colors.bluePrimary
        view1.barColor = Colors.lineLight
        view1.unitText = "mins"
        view1.categoryName = .Meditation
        view1.backgroundColor = Colors.bgZ1
        view1.textBgColor = Colors.bgZ2
        view1.numBgColor = Colors.blue5
        view1.numTextColor = Colors.blue2
        bg1.backgroundColor = Colors.bgZ1
        
        view2.backgroundColor = Colors.bgZ1
        bg2.backgroundColor = Colors.bgZ1
        
        view3.backgroundColor = Colors.bgZ1
        bg3.backgroundColor = Colors.bgZ1
        
        navigationView.addSubview(backBtn)
        navigationView.addSubview(screenShotBtn)
        
        navigationView.addSubview(titleLabel)
        self.view.bringSubviewToFront(navigationView)
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = Colors.textLv1
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        backBtn.setImage(#imageLiteral(resourceName: "icon_back_color"), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backBtn.snp.makeConstraints {
            $0.height.width.equalTo(44)
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview()
        }
        screenShotBtn.setImage(#imageLiteral(resourceName: "icon_share"), for: .normal)
        screenShotBtn.addTarget(self, action: #selector(screenShotAction), for: .touchUpInside)
        screenShotBtn.snp.makeConstraints {
            $0.height.width.equalTo(44)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
        if let service = service {
            view1.values = service.listModel.last7meditation
            view2.count = service.totalTime
            view2.number = service.recordList.count - service.dataIndex
            view3.course = (service.courseName, "")
            if service.courseName == "UNGUIDED" || service.courseName == "unguide"{
                 self.head3.barButton.isHidden = true
             } else {
                 self.head3.barButton.isHidden = false
             }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm M.d.yyyy"
            self.navigationItem.title =  dateFormatter.string(from: service.meditationTime)
            titleLabel.text = dateFormatter.string(from: service.meditationTime)
        }
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //navigationController?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shareCondition()
    }

    
    private func setShadow(view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 6
    }
    
    public var isShare: Bool{
        get {
            var pass = false
            if let service = service {
                
                if service.duration >= 8 {
                    pass = true
                }
                
                if pass && service.totalTime > 30 { //多余30分钟
                    pass = true
                } else {
                    pass = false
                }
                
                if pass {
                    pass = false
                    if service.listModel.last7meditation.count > 1 {
                        let array = service.listModel.last7meditation
                        let total = array.reduce(0, +)
                        let averageValue = CGFloat(total) / CGFloat(array.count)
                        if array[0] > array[1] && array[0] > Int(averageValue) {
                            pass = true
                        }
                    }
                }
            } else {
                pass = false
            }
            return pass
        }
    }
    
    //显示分享条件
    private func shareCondition() {
        
        var play = true
        #if DEBUG
        play = true
        #else
        play = isShare

        #endif

        if let service = service, play {
            let status = Preference.getShareStatus(id: service.recordId)
            if status >> 1 & 1 == 0 {
                Preference.setShareStatus(id: service.recordId, status: status | 2)
                //todo
                self.navigationView.addSubview(animationView)

                animationView.animation = Animation.named("share")
                animationView.contentMode = .scaleAspectFit
                animationView.loopMode = .repeat(2)
                animationView.shouldRasterizeWhenIdle = true
                animationView.play()
                animationView.snp.makeConstraints {
                    $0.width.height.equalTo(64)
                    $0.center.equalTo(screenShotBtn.snp.center)
                }
                screenShotBtn.isHidden = true

                let stopAnimationBtn = UIButton()
                self.navigationView.addSubview(stopAnimationBtn)
                stopAnimationBtn.setTitle("", for: .normal)
                stopAnimationBtn.backgroundColor = .clear
                stopAnimationBtn.addTarget(self, action: #selector(stopAnimation(_:)), for: .touchUpInside)
                stopAnimationBtn.snp.makeConstraints {
                    $0.height.width.equalTo(44)
                    $0.center.equalTo(screenShotBtn.snp.center)
                }

                let shareIV = UIImageView(image: #imageLiteral(resourceName: "img_share_progress"))
                self.view.addSubview(shareIV)
                shareIV.snp.makeConstraints {
                    $0.top.equalTo(self.navigationView.snp.bottom).offset(-18)
                    $0.right.equalToSuperview().offset(-6)
                    $0.width.equalTo(175)
                    $0.height.equalTo(87)
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
                    self.screenShotBtn.isHidden = false
                    shareIV.removeFromSuperview()
                    self.animationView.removeFromSuperview()
                    stopAnimationBtn.removeFromSuperview()
                }
            }
        }
    }
    
    //MARK: - Action
    
    @objc
    func showWeb() {
//        if let _ = self.navigationController {
//            self.presentSafari(key: .last7Times,  FTRemoteConfigKeyDefaultValue.last7times)
//        } else {
//            self.view.superview?.paretViewController()?.presentSafari(key: .last7Times, FTRemoteConfigKeyDefaultValue.last7times)
//        }
        if let url = FTRemoteConfig.shared.getConfig(key: .last7Times) {
            let sf = SFSafariViewController(url: URL(string: url)!)
            self.present(sf, animated: true, completion: nil)
        }

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
        guard let _ = service else {return}
//        
//        let courseName = service!.courseName
//        if courseName == "UNGUIDED" || courseName == "unguide" {
//            return
//        }
//        let userCourse = Preference.localCoursesList.filter{ $0.name == courseName }
//        if let course = userCourse.first  {
//            let controller = LessonsViewController()
//            controller.course = course
//            controller.hidesBottomBarWhenPushed = true
//            controller.modalPresentationStyle = .fullScreen
//
//            if let _ = self.navigationController {
//                self.navigationController?.pushViewController(controller, animated: true)
//                
//            } else {
//                self.view.superview?.paretViewController()?.navigationController?.pushViewController(controller, animated: true)
//            }
//        }

    }
    
    @objc
    private func screenShotAction() {
        screenShotBtn.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            self.screenShotBtn.isEnabled = true
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M.d.yyyy"
        let timeString =  dateFormatter.string(from: service!.meditationTime)
        bg.saveScreenAndShare(timeString: timeString)
       
    }
    
    
    @objc
    private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func stopAnimation(_ sender: UIButton) {
        screenShotBtn.isHidden = false
        animationView.stop()
        animationView.removeFromSuperview()
        screenShotAction()
        sender.removeFromSuperview()
    }
}
