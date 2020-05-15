//
//  FlowtimeConnectTipViewController.swift
//  Flowtime
//
//  Created by Anonymous on 2019/5/5.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class FlowtimeConnectTipViewController: UIViewController {

    @IBOutlet weak var imageBg: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Analytics.setScreenName("蓝牙连接操作介绍界面", screenClass: "FlowtimeConnectTipViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = Colors.bg1
        imageBg.backgroundColor = Colors.green5
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switch BLEService.shared.bleManager.state  {
        case .connected(_):
            self.navigationController?.dismiss(animated: true, completion: nil)
        default:
            break
        }

    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func nextAction(_ sender: UIButton) {
        let controller = DeviceStatusViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
