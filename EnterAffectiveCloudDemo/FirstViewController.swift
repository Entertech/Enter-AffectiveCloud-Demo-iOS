//
//  FirstViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/12.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import EnterBioModuleBLEUI
import SVProgressHUD

class FirstViewController: UIViewController {

    @IBOutlet weak var connectionBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setConnectionButtonImage()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func setUI() {
        startBtn.layer.cornerRadius = 22.5
        startBtn.layer.masksToBounds = true
        firstView.layer.borderColor = UIColor.gray.cgColor
        firstView.layer.borderWidth = 0.5
        firstView.layer.cornerRadius = 8
        firstView.layer.masksToBounds = true
        secondView.layer.borderColor = UIColor.gray.cgColor
        secondView.layer.borderWidth = 0.5
        secondView.layer.cornerRadius = 8
        secondView.layer.masksToBounds = true
        thirdView.layer.borderColor = UIColor.gray.cgColor
        thirdView.layer.borderWidth = 0.5
        thirdView.layer.cornerRadius = 8
        thirdView.layer.masksToBounds = true
    }

    @IBAction func showMeditation(_ sender: Any) {
        if BLEService.shared.bleManager.state == .disconnected {
            SVProgressHUD.showError(withStatus: "请先连接设备")
        } else {
            let medition = MeditationViewController()
            medition.modalPresentationStyle = .fullScreen
            self.present(medition, animated: true, completion: nil)
        }

    }
    @IBAction func connectBLE(_ sender: Any) {
        let ble = BLEService.shared.bleManager
        let connection = BLEConnectViewController(bleManager: ble)
//        connection.firmwareVersion  = "2.2.2"
//        connection.firmwareURL = Bundle.main.url(forResource: "dfutest0730-1", withExtension: "zip")
//        connection.firmwareUpdateLog = "1.请在此输入日志信息。\n2.更新内容1。\n3.更新内容2。"
        connection.cornerRadius = 6
        connection.mainColor = UIColor(red: 0, green: 100.0/255.0, blue: 1, alpha: 1)

        self.present(connection, animated: true, completion: nil)
    }
    
    public func setConnectionButtonImage() {
        if BLEService.shared.bleManager.state.isConnected {
            if let per = BLEService.shared.bleManager.battery?.percentage  {
                let battery = per / 100
                var imageName: String?
                if battery > 0.9 {
                    imageName = "icon_battery_100"
                } else if battery > 0.7 && battery <= 0.9 {
                    imageName = "icon_battery_80"
                } else if battery > 0.5 && battery <= 0.7 {
                    imageName = "icon_battery_60"
                } else if battery > 0.2 && battery <= 0.5 {
                    imageName = "icon_battery_40"
                } else {
                    imageName = "icon_battery_10"
                }
                self.connectionBtn.setImage(UIImage(named: imageName!), for: .normal)
            }
            
        } else {
            self.connectionBtn.setImage(UIImage(named: "icon_flowtime_disconnected"), for: .normal)
        }
    }

}

