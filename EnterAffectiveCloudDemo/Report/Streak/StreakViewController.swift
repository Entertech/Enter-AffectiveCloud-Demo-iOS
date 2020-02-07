//
//  StreakViewController.swift
//  Flowtime
//
//  Created by Enter on 2020/1/3.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import Moya
import Networking
import SVProgressHUD
import RxSwift

class Streak2ViewController: UIViewController {
    var service: ReportService?
    private let totalView = TotalView()
    private var streakView: StreakView?
    private let disposeBag  = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        streakView = StreakView()
        self.view.addSubview(totalView)
        self.view.addSubview(streakView!)
        totalView.layer.shadowColor = UIColor.black.cgColor
        totalView.layer.shadowOffset = CGSize(width: 1, height: 4)
        totalView.layer.shadowOpacity = 0.1
        totalView.layer.shadowRadius = 8
        streakView?.layer.shadowColor = UIColor.black.cgColor
        streakView?.layer.shadowOffset = CGSize(width: 1, height: 4)
        streakView?.layer.shadowOpacity = 0.1
        streakView?.layer.shadowRadius = 8
        
        totalView.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(133)
        }
        streakView?.snp.makeConstraints{
            $0.top.equalTo(totalView.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(313)
        }
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Statistics"
        navigationController?.setNavigationBarHidden(false, animated: true)
        streakRequest()
    }
    
    //Streak Request
    private func streakRequest() {
        let request = UserStreakRequest()
        SVProgressHUD.show()
        request.userStreak.subscribe(onNext: { (modelList) in
            if modelList.count > 0 {
                let model = modelList.first!
                self.totalView.daysCountLabel.text = String(model.totalDays)
                self.totalView.lessonCountLabel.text = "\(self.service!.recordList.count)"
                self.totalView.timeCountLabel.text = "\(self.service!.totalTime)"
                self.streakView?.currentStreakLabel.text = String(model.currentStreak)
                self.streakView?.longestStreakLabel.text = String(model.longestStreak)
                if let updateAt = model.updated_at {
                    if updateAt.isThisMonth()  {
                        self.streakView?.streakDateView.dateStreak = model.active_days
                    } else {
                        self.streakView?.streakDateView.dateStreak  = []
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
            }, onDisposed: nil).disposed(by: disposeBag)    }


}
