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
    var bIsShowedAppUpdate = false
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setConnectionButtonImage()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FTRemoteConfig.shared.shouldUpdateApp() && !bIsShowedAppUpdate {
            bIsShowedAppUpdate = true
            let updateVC = FirmwareUpdateViewController()
            updateVC.modalPresentationStyle = .fullScreen
            updateVC.stateValue = 0
            updateVC.noteValue = "有新版本更新，请到苹果商城下载"
            self.present(updateVC, animated: true, completion: nil)
        }
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
            let controller = SensorCheckViewController()
            controller.state = .check
            let navigation = UINavigationController(rootViewController: controller)
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true, completion: nil)
//            self.navigationController?.pushViewController(navigation, animated: true)
            
//            let medition = MeditationViewController()
//            medition.modalPresentationStyle = .fullScreen
//            self.present(medition, animated: true, completion: nil)
        }
        


    }
    @IBAction func connectBLE(_ sender: Any) {
        if Preference.haveFlowtimeConnectedBefore {
            
            let controller = DeviceStatusViewController()
            controller.hidesBottomBarWhenPushed = true
            //controller.state = .check
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = FlowtimeConnectTipViewController()
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
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

