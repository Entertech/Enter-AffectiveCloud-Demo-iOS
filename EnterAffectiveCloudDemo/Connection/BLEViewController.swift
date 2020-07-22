//
//  BLEViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2020/5/12.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import QuickTableViewController
import EnterBioModuleBLE
import SafariServices
import RxSwift

class BLEViewController: QuickTableViewController, BLEStateDelegate {
    let ble = BLEService.shared.bleManager
    private let dispose = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.layout()
        tableView.tableHeaderView = _headerView
        tableView.isScrollEnabled = false
        tableView.backgroundColor = Colors.bg2
        if Device.current.isiphoneX {
            tableView.contentInset = UIEdgeInsets(top: -44, left: 0, bottom: 0, right: 0)
        } else {
            tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        }
        updateView(with: ble.state)
        //Analytics.setScreenName("蓝牙连接界面", screenClass: "BLEViewController")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        _connectingView.stopAnimation()
        if let timer = timer {
            if timer.isValid {
                timer.invalidate()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotification.Name("BLEConnectionStateNotify").observe(sender: self, selector: #selector(bleConnectionState(_:)))
        NSNotification.Name("BatteryNotify").observe(sender: self, selector: #selector(bleBattery(_:)))
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        _connectingView.resumeIfNeeded()
    }

    private func emptyNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private let _headerView = UITableViewHeaderFooterView()
    private let _connectingView: ConnectingView = ConnectingView()
    private let _batteryView: BatteryView = BatteryView()
    private let maskDark = BackgroundView(frame: CGRect.zero)
    private func setup() {
        
        _headerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 320)
        _headerView.contentView.addSubview(maskDark)
        maskDark.backgroundColor = Colors.maskDark
        _headerView.contentView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3568627451, blue: 0.4980392157, alpha: 1)
        _headerView.contentView.addSubview(_connectingView)
        _headerView.contentView.addSubview(_batteryView)
        let backBtn = UIButton()
        backBtn.setImage(#imageLiteral(resourceName: "icon_navigation_back_white"), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
        _headerView.contentView.addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(32)
            $0.width.height.equalTo(44)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "Flowtime"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        _headerView.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backBtn.snp.centerY)
        }
    }

    private func layout() {
        tableView.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(0)
        }

        _connectingView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(60)
            $0.width.equalTo(150)
            $0.height.equalTo(150)
        }
        _batteryView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(60)
            $0.width.equalTo(150)
            $0.height.equalTo(150)
        }
        maskDark.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func reloadTable(_ deviceInfo: BLEDeviceInfo, isEnable: Bool = false ) {
        var table: [Section] = []

        let row1 = NavigationRow(text: "硬件版本", detailText: .value1(deviceInfo.hardware), icon: Icon.image(#imageLiteral(resourceName: "icon_hardware_version")), customization: { (cell, row) in
            if isEnable {
                cell.contentView.alpha = 1.0
            } else {
                cell.contentView.alpha = 0.5
            }
        }, action: nil, accessoryButtonAction: nil)

        let row2:NavigationRow<UITableViewCell>
        if isEnable {
            let currentVersion = deviceInfo.firmware
            let currentVerNum = Int(currentVersion.replacingOccurrences(of: ".", with: ""))
            Preference.currnetFirmwareVersion = currentVerNum ?? 9999
           row2 = NavigationRow(text: "固件版本", detailText: .value1(deviceInfo.firmware), icon: Icon.image(#imageLiteral(resourceName: "icon_firmware_version")), customization: { (cell, row) in
                if isEnable {
                    cell.contentView.alpha = 1.0
                } else {
                    cell.contentView.alpha = 0.5
                }
            }, accessoryButtonAction: nil)
        } else {
            row2 = NavigationRow(text: "固件版本", detailText: .value1(deviceInfo.firmware), icon: Icon.image(#imageLiteral(resourceName: "icon_firmware_version")), customization: { (cell, row) in
                if isEnable {
                    cell.contentView.alpha = 1.0
                } else {
                    cell.contentView.alpha = 0.5
                }
            }, action: nil, accessoryButtonAction: nil)
        }

        let row3 = NavigationRow(text: "蓝牙地址", detailText: .value1(deviceInfo.mac), icon: Icon.image(#imageLiteral(resourceName: "icon_bluetooth")), customization: { (cell, row) in
            if isEnable {
                cell.contentView.alpha = 1.0
            } else {
                cell.contentView.alpha = 0.5
            }
        }, action: nil, accessoryButtonAction: nil)
        table.append(Section(title: nil, rows: [row1, row2, row3]))


        let row10 = NavigationRow(text: "Flowtime头环信息", detailText: .none, icon: Icon.image(#imageLiteral(resourceName: "icon_flowtime_knowmore")), customization: nil, action: { (row) in
            //Appearance.setRecord("1002", "蓝牙连接界面 头环介绍")
            if let urlStr = FTRemoteConfig.shared.getConfig(key: .introduce), let url = URL(string: urlStr){
                let sf = SFSafariViewController(url: url)
                self.present(sf, animated: true, completion: nil)
            }
        }, accessoryButtonAction: nil)

        let row11 = NavigationRow(text: "无法连接头环?", detailText: .none, icon: Icon.image(#imageLiteral(resourceName: "icon_disconnect_small")), customization: nil, action: { (row) in
            //Appearance.setRecord("1003", "蓝牙连接界面 连接问题")
            if let urlStr = FTRemoteConfig.shared.getConfig(key: .cannotConnect), let url = URL(string: urlStr){
                let sf = SFSafariViewController(url: url)
                self.present(sf, animated: true, completion: nil)
            }
        }, accessoryButtonAction: nil)

        var rows1 = [row10, row11]
        if ble.state.isConnected {
            rows1.remove(at: 1)
        }
        table.append(Section(title: nil, rows: rows1))

        self.tableContents = table
    }
    
    @objc
    func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
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
    
    @objc
    func bleBattery(_ noti: Notification) {
        let value = noti.userInfo!["value"] as! Battery
        _batteryView.power = value
    }
    
    //MARK: - BLE delegate
//    func bleConnectionStateChanged(state: BLEConnectionState, bleManager: BLEManager) {
//        dispatch_to_main {
//            self.updateView(with: state)
//        }
//    }
//    func bleBatteryReceived(battery: Battery, bleManager: BLEManager) {
//        _batteryView.power = battery
//    }

    private var timer: Timer?

    // MARK: - Update View
    private func updateView(with state: BLEConnectionState) {
        switch state {
        case .searching, .connecting:
            _batteryView.isHidden = true
            _batteryView.power = ble.battery
            _connectingView.isHidden = false
            _connectingView.state = .connecting
            self.colorAnimate(to: #colorLiteral(red: 0.3333333333, green: 0.3568627451, blue: 0.4980392157, alpha: 1))
            delay(seconds: 0.5) {[unowned self] in
                self.reloadTable(self.ble.deviceInfo, isEnable: false)
            }
            if let timer = timer {
                if timer.isValid {
                    timer.invalidate()
                }
            }
            
            timer = Timer.scheduledTimer(withTimeInterval: 6, repeats: false, block: { (timer) in
                BLEService.shared.bleManager.disconnect()
            })
        case .connected:
            if !Preference.haveFlowtimeConnectedBefore {
                Preference.haveFlowtimeConnectedBefore = true
            }
            
            _batteryView.isHidden = false
            _batteryView.power = ble.battery
            _connectingView.isHidden = true
            _connectingView.state = .suspend(isConnected: true)
            self.colorAnimate(to: #colorLiteral(red: 0.2941176471, green: 0.3647058824, blue: 0.8, alpha: 1))
            delay(seconds: 0.5) {[unowned self] in
                self.reloadTable(self.ble.deviceInfo, isEnable: true)
            }
            if let timer = timer {
                if timer.isValid {
                    timer.invalidate()
                }
            }
        case .disconnected:
            _batteryView.isHidden = true
            _batteryView.power = ble.battery
            _connectingView.isHidden = false
            _connectingView.state = .suspend(isConnected: false)
            self.colorAnimate(to: #colorLiteral(red: 0.9843137255, green: 0.6117647059, blue: 0.5960784314, alpha: 1))
            delay(seconds: 0.5) {[unowned self] in
                self.reloadTable(self.ble.deviceInfo, isEnable: false)
            }
            if let timer = timer {
                if timer.isValid {
                    timer.invalidate()
                }
            }
        }
    }

    private func colorAnimate(to: UIColor) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self._headerView.contentView.backgroundColor = to
        }, completion: nil)
    }

    private func backAction() {
        switch ble.state {
        case .connected(_):
            self.navigationController?.popViewController(animated: true)
            break
        default:
            self.navigationController?.popViewController(animated: true)
            ble.disconnect()
        }
    }
}


extension QuickTableViewController {
    // tableview header view
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
}
