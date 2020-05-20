//
//  SecondViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/12.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    let reportView = MainReportViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        reportView.pViewController = self
        self.view.addSubview(reportView.view)
        reportView.view.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        if let data = MeditationRepository.query(Preference.userID) {
            reportView.meditationDB = data.last
        }
        let listBtn = UIButton()
        listBtn.setImage(#imageLiteral(resourceName: "icon_statistics_list"), for: .normal)
        listBtn.addTarget(self, action: #selector(backToList), for: .touchUpInside)
        let leftBtn = UIBarButtonItem.init(customView: listBtn)
        self.navigationItem.leftBarButtonItem = leftBtn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reportView.viewWillAppear(animated)
        let data = MeditationRepository.query(Preference.userID)

        if let data = data, data.count > 0 {
            let meditationDate = Date.date(dateString: data.last!.startTime, custom: "yyyy-MM-dd HH:mm:ss")
            if let mDate = meditationDate {
                self.navigationItem.title = mDate.string(custom: "M.d.yyyy")
            } else {
                self.navigationItem.title = "0.0.2000"
            }
        } else {
            self.navigationItem.title = "0.0.2020"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reportView.viewWillDisappear(animated)
    }
 
    @objc
    private func backToList() {
        let listVC = ReportListViewController()
        listVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(listVC, animated: true)
    }
}

