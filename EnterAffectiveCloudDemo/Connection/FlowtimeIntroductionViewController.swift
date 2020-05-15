//
//  FlowtimeIntroductionViewController.swift
//  Flowtime
//
//  Created by Anonymous on 2019/5/5.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import SafariServices
import FluentDarkModeKit
//import Firebase

class FlowtimeIntroductionViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgeBg: UIView!
    @IBOutlet weak var flowtimeLabel: UILabel!
    @IBOutlet weak var text1: UILabel!
    @IBOutlet weak var text2: UILabel!
    @IBOutlet weak var text3: UILabel!
    @IBOutlet weak var text4: UILabel!
    @IBOutlet weak var connectBtn: UIButton!
    @IBOutlet weak var knowMoreBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Analytics.setScreenName("设备介绍界面（首次连接）", screenClass: "FlowtimeIntroductionViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = Colors.bg1
        self.titleLabel.textColor = Colors.textLv1
        self.imgeBg.backgroundColor = Colors.yellow5
        flowtimeLabel.textColor = Colors.textLv1
        text1.textColor = Colors.textLv2
        text2.textColor = Colors.textLv1
        text3.textColor = Colors.textLv1
        text4.textColor = Colors.textLv1
        knowMoreBtn.titleLabel?.textColor = Colors.textLv2
    }

    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func knowMoreAction(_ sender: UIButton) {
        if let url = URL(string: "https://www.notion.so/I-can-t-connect-the-headband-with-the-app-1ae10dc7fe1049c4953fc879f9042730") {
            let sf = SFSafariViewController(url: url)
            present(sf, animated: true, completion: nil)
        }
    }

    @IBAction func connectAction(_ sender: UIButton) {
        let controller = FlowtimeConnectTipViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
