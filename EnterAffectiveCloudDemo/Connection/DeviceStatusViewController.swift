//
//  DeviceStatusViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/5/7.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import EnterBioModuleBLE
import SafariServices

class DeviceStatusViewController: UIViewController, BLEStateDelegate{
    
    
    let ble = BLEService.shared.bleManager
    private let connectView = DeviceStatusView()
    private let guideView = GuideView()
    private let wearGuideView = WearGuideView()
    private let connectGuideView = HowToConnectGuideView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //开启通知和代理
        NSNotification.Name("BLEConnectionStateNotify").observe(sender: self, selector: #selector(bleConnectionState(_:)))
        NSNotification.Name("BatteryNotify").observe(sender: self, selector: #selector(bleBattery(_:)))
        //RelaxManager.shared.delegate = self
        // 判断连接状态
        if ble.state.isConnected {
            
            connectView.state = .suspend(isConnected: true)
            connectView.batteryView.power = ble.battery
            //RelaxManager.shared.setupBLE()
            wearGuideView.isHidden = false
        } else {
            if BluetoothContext.shared.manager.state != .poweredOn {
                showAlert()
                connectView.state = .suspend(isConnected: false)
                return
            }
            if !ble.state.isBusy {
                try? ble.scanAndConnect(completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.navigationController?.topViewController is FirstViewController {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        //RelaxManager.shared.delegate = nil
        NotificationCenter.default.removeObserver(self)
        if let timer = timer {
            if timer.isValid {
                timer.invalidate()
            }
        }
    }
    
    // UI实现
    private func setUI() {
        self.view.backgroundColor = Colors.bg1
        let backBtn = UIButton()
        backBtn.setImage(#imageLiteral(resourceName: "icon_back_color"), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
        self.view.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(8)
            $0.width.height.equalTo(44)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "设备状态"
        titleLabel.textColor = Colors.textLv1
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        self.view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backBtn.snp.centerY)
        }
        
        self.view.addSubview(connectView)
        connectView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(60)
            $0.height.equalTo(240)
        }
        connectView.layer.cornerRadius = 8
        connectView.layer.shadowColor = UIColor.black.cgColor
        connectView.layer.shadowOffset = CGSize(width: 0, height: 5)
        connectView.layer.shadowRadius = 8
        connectView.layer.shadowOpacity = 0.1
        
        connectView.restoreBtn.addTarget(self, action: #selector(restoreAction), for: .touchUpInside)
        connectView.showInfoBtn.addTarget(self, action: #selector(pushAction), for: .touchUpInside)
        
        guideView.message = "查看指南了解如何使用头环以获得良好信号。"
        self.view.addSubview(guideView)
        guideView.isHidden = Preference.deviceStatusGuide
        guideView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            if !Preference.deviceStatusGuide {
                $0.height.equalTo(60)
            } else {
                $0.height.equalTo(0)
            }
            
            $0.top.equalTo(connectView.snp.bottom).offset(16)
        }
        guideView.layer.cornerRadius = 8
        guideView.closeButton.addTarget(self, action: #selector(guideViewClose), for: .touchUpInside)
        
        self.view.addSubview(wearGuideView)
        wearGuideView.snp.makeConstraints {
            if !Preference.deviceStatusGuide {
                $0.top.equalTo(guideView.snp.bottom).offset(16)
            } else {
                $0.top.equalTo(guideView.snp.bottom)
            }
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(110)
        }
        wearGuideView.layer.cornerRadius = 8
        wearGuideView.layer.shadowColor = UIColor.black.cgColor
        wearGuideView.layer.shadowOffset = CGSize(width: 0, height: 5)
        wearGuideView.layer.shadowRadius = 8
        wearGuideView.layer.shadowOpacity = 0.1
        wearGuideView.moreInfoBtn.addTarget(self, action: #selector(guideInfoAction), for: .touchUpInside)
        wearGuideView.isHidden = true
        //wearGuideView.sensorCheckView.checkValue = App.lastSensorState
        
        self.view.addSubview(connectGuideView)
        connectGuideView.snp.makeConstraints {
            $0.top.equalTo(self.connectView.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        connectGuideView.layer.cornerRadius = 8
        connectGuideView.layer.shadowColor = UIColor.black.cgColor
        connectGuideView.layer.shadowOffset = CGSize(width: 0, height: 5)
        connectGuideView.layer.shadowRadius = 8
        connectGuideView.layer.shadowOpacity = 0.1
        connectGuideView.moreInfoBtn.addTarget(self, action: #selector(connectGuideAction), for: .touchUpInside)
        connectGuideView.isHidden = true
        
    }

    // MARK: - Action
    @objc
    func guideViewClose() {
        guideView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        wearGuideView.snp.updateConstraints {
            $0.top.equalTo(guideView.snp.bottom).offset(0)
        }
        Preference.deviceStatusGuide = true
    }
    
    @objc
    func restoreAction() {
        if BluetoothContext.shared.manager.state != .poweredOn {
            showAlert()
            return
        }

        // reconnect bluetooth
        do {
            try ble.scanAndConnect { (flag) in
                if flag {
                    print("connect success")
                } else {
                    print("connect failed")
                }
            }
        } catch {
            print("unknow error \(error)")
        }
    }
    // 返回实现
    @objc
    func backAction(_ sender: UIButton) {
        if let first = self.navigationController?.viewControllers.first,
            first.isKind(of: SensorCheckViewController.classForCoder()) {
            self.navigationController?.popViewController(animated: true)
        } else {
            if let first = self.navigationController?.viewControllers.first,
                first.isKind(of: FlowtimeIntroductionViewController.classForCoder()) {
                self.navigationController?.dismiss(animated: true, completion: nil)
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    @objc
    func pushAction() {
        let controller = BLEViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "蓝牙权限未开启",
                                      message: "请在设置中开启蓝牙权限",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    func guideInfoAction() {
        let checkVC = SensorCheckViewController()
        checkVC.state = .fix
        self.navigationController?.pushViewController(checkVC, animated: true)
    }
    // MARK: - notification Update View
    @objc
    func bleConnectionState(_ noti: Notification) {
        let value = noti.userInfo!["value"] as! Int
        var state: BLEConnectionState?
        switch value {
        case 0:
            state = .disconnected
            //Logger.shared.upload(event: "Bluetooth disconnected", message: "")
        case 1:
            state = .searching
            //Logger.shared.upload(event: "Bluetooth scanning", message: "")
        case 2:
            state = .connecting
            //Logger.shared.upload(event: "Bluetooth connecting", message: "")
        case 3:
            state = .connected(0)
            //RelaxManager.shared.setupBLE()
            //Logger.shared.upload(event: "Bluetooth connect complete", message: "")
        default:
            break
        }
        if let state = state {
            DispatchQueue.main.async {
                self.updateView(with: state)
            }
        }
    }
    
    private var timer: Timer?
    
    private func updateView(with state: BLEConnectionState) {
        switch state {
        case .searching, .connecting:
            if let timer = timer {
                if timer.isValid {
                    timer.invalidate()
                }
            }
            connectView.state = .connecting
            wearGuideView.isHidden = true
            connectGuideView.isHidden = true
             guideView.isHidden = true
            timer = Timer.scheduledTimer(withTimeInterval: 6, repeats: false, block: { (timer) in
                BLEService.shared.bleManager.disconnect()
            })
        case .connected:
            print("connected  \(Date())")
            connectView.state = .suspend(isConnected: true)
            wearGuideView.isHidden = false
            guideView.isHidden = false
            connectGuideView.isHidden = true
            if let timer = timer {
                if timer.isValid {
                    timer.invalidate()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                Preference.haveFlowtimeConnectedBefore = true
                Preference.hardwareMac = self.ble.deviceInfo.mac
                // 蓝牙连接
                if let version = Int(self.ble.deviceInfo.firmware.replacingOccurrences(of: ".", with: "")) {
                    Preference.currnetFirmwareVersion = version
                    if Preference.bIsDownloadFirmware && Preference.currnetFirmwareVersion < Preference.updateFirmwareVersion
                        && BLEService.shared.bleManager.state.isConnected {
                        RelaxManager.shared.clearBLE()
                        let firmwareUpdateVC = FirmwareUpdateViewController()
                        firmwareUpdateVC.modalPresentationStyle = .fullScreen
                        firmwareUpdateVC.noteValue = ""
                        firmwareUpdateVC.stateValue = 1
                        self.present(firmwareUpdateVC, animated: true)
                    }
                    
                }
            })
        case .disconnected:
            connectView.state = .suspend(isConnected: false)
            wearGuideView.isHidden = true
            guideView.isHidden = true
            connectGuideView.isHidden = false
            if let timer = timer {
                if timer.isValid {
                    timer.invalidate()
                }
            }
        }
    }
    //MARK: - battery
    @objc
    func bleBattery(_ noti: Notification) {
        let value = noti.userInfo!["value"] as! Battery
        connectView.batteryView.power = value
    }
    
    //MARK: - Sensor Check Delegate
    func wearListen(wear: UInt8) {
        //wearGuideView.sensorCheckView.checkValue = wear
        //App.lastSensorState = wear
    }
    
    @objc
    func connectGuideAction() {
        let urlStr = FTRemoteConfig.shared.getConfig(key: .cannotConnect)!
        presentSafari(urlStr)
    }
    
    /// Safari 显示网页
    private func presentSafari(_ defaultKey: String) {
        if let url = URL(string: defaultKey) {
            let sf = SFSafariViewController(url: url)
            present(sf, animated: true, completion: nil)
        }
    }
}
