//
//  Statistics2ViewController.swift
//  Flowtime
//
//  Created by Enter on 2019/12/27.
//  Copyright © 2019 Enter. All rights reserved.
//

import RxSwift
import Moya
import Networking
import SVProgressHUD
import RxCocoa
import StoreKit
import Lottie

class Statistics2ViewController: UIViewController {
    public var isExample = false
    public var listIndex = 0
    public var isHiddenNavigationBar = true
    private var isLoadView = true
    private var viewModel = ReportService()
    var reportVC = MainReportViewController()
    var reportTotal = TotalViewController()
    var navigationView = UIView()
    private let totalView = TotalView()
    private let streakView = StreakView()
    private let segment = UISegmentedControl()
    private let backBtn = UIButton()
    private let screenShotBtn = UIButton()
    private let animationView = AnimationView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setCharts()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.largeTitleDisplayMode = .never
        navigationController?.setNavigationBarHidden(isHiddenNavigationBar, animated: true)
        navigationItem.title = "分类"
        //navigationController?.delegate = self
        if isLoadView {
            isLoadView = false
        } else {
            setCharts()
        }
        updateUI()
        if viewModel.recordList[viewModel.dataIndex].meditationID != 0 {
            reportTotal.view.isHidden = true
            reportVC.view.isHidden = false
        } else {
            reportVC.view.isHidden = true
            reportTotal.view.isHidden = false
            reportTotal.service = viewModel
            reportTotal.scrollViewTopLayout.constant = 0
            reportTotal.navigationView.isHidden = true
            reportTotal.navigationBg.isHidden = true
        }
        
        if viewModel.recordList[viewModel.dataIndex].meditationID == -1 {
            self.reportVC.bg0.isHidden = false
            self.reportVC.bg1top.constant = 193
        } else {
            self.reportVC.bg0.isHidden = true
            self.reportVC.bg1top.constant = 16
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.reportVC.askForStartsView.laterBtn.addTarget(self, action: #selector(startsLater), for: .touchUpInside)
        self.reportVC.askForStartsView.likeBtn.addTarget(self, action: #selector(startsLike), for: .touchUpInside)
        self.shareCondition()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        segment.selectedSegmentIndex = 0
    }
    
    private func setUp() {
        //viewmodel
        viewModel.mainReport = reportVC
        //ui
        self.view.backgroundColor = Colors.bg1
        reportVC.view.backgroundColor = Colors.bg2
        reportTotal.view.backgroundColor = Colors.bg2
        navigationView.backgroundColor = Colors.bgZ1
        self.view.addSubview(totalView)
        self.view.addSubview(streakView)
        self.view.addSubview(navigationView)
        self.view.addSubview(reportVC.view)
        self.view.addSubview(reportTotal.view)
        
        let item = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_share").withRenderingMode(.alwaysOriginal), style:
            .plain, target: self, action: #selector(screenShotAction))
        
        navigationItem.rightBarButtonItem = item
        
        segment.addTarget(self, action: #selector(self.segmentValueChange(_:)), for: .valueChanged)
        backBtn.setImage(#imageLiteral(resourceName: "icon_statistics_list"), for: .normal)
        backBtn.addTarget(self, action: #selector(backToList), for: .touchUpInside)
        screenShotBtn.setImage(#imageLiteral(resourceName: "icon_share"), for: .normal)
        screenShotBtn.addTarget(self, action: #selector(screenShotAction), for: .touchUpInside)
        
        navigationView.addSubview(segment)
        navigationView.addSubview(backBtn)
        navigationView.addSubview(screenShotBtn)
        
        totalView.layer.shadowColor = UIColor.black.cgColor
        totalView.layer.shadowOffset = CGSize(width: 1, height: 4)
        totalView.layer.shadowOpacity = 0.1
        totalView.layer.shadowRadius = 8
        streakView.layer.shadowColor = UIColor.black.cgColor
        streakView.layer.shadowOffset = CGSize(width: 1, height: 4)
        streakView.layer.shadowOpacity = 0.1
        streakView.layer.shadowRadius = 8
        segment.insertSegment(withTitle: "旅程", at: 0, animated: false)
        segment.insertSegment(withTitle: "统计", at: 1, animated: false)
        segment.selectedSegmentIndex = 0
        
        let screenHeight = UIScreen.main.bounds.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navHeight = self.navigationController!.navigationBar.frame.size.height
        let tabHeight = self.tabBarController!.tabBar.frame.size.height
        let viewHeight = screenHeight - statusBarHeight - navHeight - tabHeight
        
        navigationView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(self.view.snp.top)
            if UIDevice.current.isiphoneX {
                $0.height.equalTo(88)
            } else {
                $0.height.equalTo(64)
            }
        }
        
        screenShotBtn.snp.makeConstraints {
            $0.height.width.equalTo(44)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
        
        backBtn.snp.makeConstraints {
            $0.height.width.equalTo(44)
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview()
        }
    
        segment.snp.makeConstraints {
            $0.height.equalTo(29)
            $0.width.equalTo(241)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-8)
        }
        
        totalView.snp.makeConstraints{
            if self.isHiddenNavigationBar {
                $0.top.equalTo(navigationView.snp.bottom).offset(16)
            } else {
                $0.top.equalTo(self.view.safeAreaLayoutGuide)
            }
            
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(133)
        }
        streakView.snp.makeConstraints{
            $0.top.equalTo(totalView.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(313)
        }
        
        reportVC.view.snp.makeConstraints {
            if self.isHiddenNavigationBar {
                $0.top.equalTo(navigationView.snp.bottom)
            } else {
                $0.top.equalTo(self.view.safeAreaLayoutGuide)
            }
            $0.left.right.equalToSuperview()
            if let isHidden = self.tabBarController?.tabBar.isHidden, !isHidden {
                $0.height.equalTo(viewHeight)
            } else {
                $0.bottom.equalToSuperview()
            }
            
        }
        
        reportTotal.view.snp.makeConstraints {
            if self.isHiddenNavigationBar {
                $0.top.equalTo(navigationView.snp.bottom)
            } else {
                $0.top.equalTo(self.view.safeAreaLayoutGuide)
            }
            $0.left.right.equalToSuperview()
            
            if let isHidden = self.tabBarController?.tabBar.isHidden, !isHidden {
                $0.height.equalTo(viewHeight)
            } else {
                $0.bottom.equalToSuperview()
            }
        }
        self.view.bringSubviewToFront(navigationView)
    }
    
    //判断是否给分享动效
    private func shareCondition() {
        
        var play = false
        #if DEBUG
        play = false
        #else
        if viewModel.recordList[viewModel.dataIndex].meditationID != 0 {
            play = viewModel.shareCondition
        } else {
            play = reportTotal.isShare
        }

        #endif
        let status = Preference.getShareStatus(id: viewModel.recordId)
        if play && status & 1 == 0 {
            Preference.setShareStatus(id: viewModel.recordId, status: status | 1)
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
        } else {
            Preference.setShareStatus(id: viewModel.recordId, status: status | 1)
        }
    }


    //Streak Request
    private func streakRequest() {
        let request = UserStreakRequest()
        SVProgressHUD.show()
        request.userStreak.subscribe(onNext: { (modelList) in
            if modelList.count > 0 {
                let model = modelList.first!
                self.totalView.daysCountLabel.text = String(model.totalDays)
                self.totalView.lessonCountLabel.text = "\(self.viewModel.recordList.count)"
                self.totalView.timeCountLabel.text = "\(self.viewModel.totalTime)"
                self.streakView.currentStreakLabel.text = String(model.currentStreak)
                self.streakView.longestStreakLabel.text = String(model.longestStreak)
                if let updateAt = model.updated_at {
                    if updateAt.isThisMonth()  {
                        self.streakView.streakDateView.dateStreak = model.active_days
                    } else {
                        self.streakView.streakDateView.dateStreak  = []
                    }
                }
                //self._streakView.streakDateView.dateStreak = model.active_days
            }

        }, onError: { (error) in
            let err = error as! MoyaError
            print(err.localizedDescription)
            SVProgressHUD.dismiss()
        }, onCompleted: {
            SVProgressHUD.dismiss()
        }, onDisposed: nil)
    }
    
    //刷新ui
    public func setCharts() {
        viewModel.loadData()
    }
    
    
    //选择数组里的索引
    private func updateUI() {
        viewModel.dataIndex = listIndex
    }
    
    //MARK: - 设置action
    @objc
    private func screenShotAction() {
            
        screenShotBtn.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            self.screenShotBtn.isEnabled = true
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M.d.yyyy"
        let timeString =  dateFormatter.string(from: viewModel.meditationTime)
        if reportTotal.view.isHidden {
            reportVC.bg.saveScreenAndShare(timeString: timeString)
        } else {
            reportTotal.bg.saveScreenAndShare(timeString: timeString)
        }
    }


    @objc
    func showWeb() {
        
        //self.presentSafari(key: .last7Times,  FTRemoteConfigKeyDefaultValue.last7times)
    }
    
    @objc
    func startsLater() {
        UIView.animate(withDuration: 0.3) {
            self.reportVC.askForStartsHeight.constant = 0
            self.reportVC.askForStartsView.isHidden = true
        }
       
    }

    @objc
    func startsLike() {
        SKStoreReviewController.requestReview()
        Preference.showRate = false
    }
    
    @objc
    func stopAnimation(_ sender: UIButton) {
        screenShotBtn.isHidden = false
        animationView.stop()
        animationView.removeFromSuperview()
        screenShotAction()
        sender.removeFromSuperview()
    }
    
    @objc
    private func backToList() {

        let listVC = StatisticsViewController()
        listVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
    @objc
    private func segmentValueChange(_ segmentCtrl: UISegmentedControl) {
        
        switch segmentCtrl.selectedSegmentIndex {
        case 0:
            if viewModel.recordList[viewModel.dataIndex].meditationID != 0 {
                reportTotal.view.isHidden = true
                reportVC.view.isHidden = false
            } else {
                reportVC.view.isHidden = true
                reportTotal.view.isHidden = false
                reportTotal.service = viewModel
            }

        case 1:
            reportVC.view?.isHidden = true
            reportTotal.view.isHidden = true
            streakRequest()
            
        default:
            break
        }
    }
}
