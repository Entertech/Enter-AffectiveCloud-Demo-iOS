//
//  FlowtimeIntroductionViewController.swift
//  Flowtime
//
//  Created by Anonymous on 2019/5/5.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import SafariServices

class FlowtimeIntroductionViewController: UIViewController {

    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var flowtimeLabel: UILabel!
    @IBOutlet weak var text1: UILabel!
    @IBOutlet weak var text2: UILabel!
    @IBOutlet weak var text3: UILabel!
    @IBOutlet weak var text4: UILabel!
    @IBOutlet weak var connectBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = .clear
        self.titleLabel.textColor = .white
        flowtimeLabel.textColor = .white
        text1.textColor = .white
        text2.textColor = .white
        text3.textColor = .white
        text4.textColor = .white
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.init(white: 0, alpha: 0.5).cgColor,
                                UIColor.init(white: 0, alpha: 0).cgColor,
                                UIColor.init(white: 0, alpha: 0.7).cgColor]
        gradientLayer.locations = [0, 0.2, 0.5]
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0, y: 1)
        gradientLayer.frame = self.view.bounds
        bgImage.layer.insertSublayer(gradientLayer, at: 0)
    }

    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

//    @IBAction func knowMoreAction(_ sender: UIButton) {
//        if let url = FTRemoteConfig.default.url(.introduce, defaultKey: FTRemoteConfigKeyDefaultValue.introduce ) {
//            let sf = SFSafariViewController(url: url)
//            present(sf, animated: true, completion: nil)
//        }
//    }

    @IBAction func connectAction(_ sender: UIButton) {
        let controller = FlowtimeConnectTipViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
