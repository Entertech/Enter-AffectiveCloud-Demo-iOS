//
//  DeviceStatusView.swift
//  Flowtime
//
//  Created by Enter on 2020/4/9.
//  Copyright © 2020 Enter. All rights reserved.
//

import UIKit
import Lottie

class DeviceStatusView: UIView {
    
    enum State {
        case connecting
        case suspend(isConnected: Bool)
    }

    var state: State = .suspend(isConnected: false) {
        didSet {
            updateStatus()
        }
    }
    
    private let indicator = UIImageView()
    
    private let animationView: AnimationView = AnimationView(name: "连接中")
    
    private let connectingLabel = UILabel()
    private let noDeviceLabel = UILabel()
    let restoreBtn = UIButton()
    
    let showInfoBtn = UIButton()
    
    let batteryView = BatteryView()
    
    init() {
        super.init(frame: CGRect.zero)
        setUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    private func setUI() {
        self.backgroundColor = Colors.red4
        // 顶部的三个控件
        let icon = UIImageView()
        icon.image = UIImage(named: "icon_device_status")
        self.addSubview(icon)
        icon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.left.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
        }
        
        let title = UILabel()
        title.text = "Device Status"
        title.textColor = .white
        title.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        self.addSubview(title)
        title.snp.makeConstraints {
            $0.left.equalTo(icon.snp.right).offset(16)
            $0.centerY.equalTo(icon.snp.centerY)
        }
        
        indicator.image = UIImage(named: "icon_white_indicator")
        self.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-24)
            $0.centerY.equalTo(icon.snp.centerY)
        }
        
        // 动画
        self.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(ceil(100/1.5))
            $0.height.equalTo(180/1.5)
        }
        animationView.isHidden = true
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.75
        animationView.contentMode = .scaleAspectFit
        
        // 设置文字
        self.addSubview(connectingLabel)
        connectingLabel.text = "connecting..."
        connectingLabel.textColor = .white
        connectingLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        connectingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(8)
            $0.top.equalTo(animationView.snp.bottom).offset(0)
        }
        connectingLabel.isHidden = true
        
        self.addSubview(noDeviceLabel)
        noDeviceLabel.text = "No device found"
        noDeviceLabel.textColor = .white
        noDeviceLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        noDeviceLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        noDeviceLabel.isHidden = true
        
        // 设置按钮
        self.addSubview(restoreBtn)
        restoreBtn.layer.cornerRadius = 16
        restoreBtn.layer.masksToBounds = true
        restoreBtn.backgroundColor = Colors.btn2
        restoreBtn.setTitle("Restore", for: .normal)
        restoreBtn.setTitleColor(Colors.btn1, for: .normal)
        restoreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        restoreBtn.snp.makeConstraints {
            $0.width.equalTo(95)
            $0.height.equalTo(32)
            $0.bottom.equalTo(-24)
            $0.centerX.equalToSuperview()
        }
        restoreBtn.isHidden = true
        
        self.addSubview(batteryView)
        batteryView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(20)
            $0.width.equalTo(150)
            $0.height.equalTo(150)
        }
        batteryView.isHidden = true
        
        self.addSubview(showInfoBtn)
        showInfoBtn.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func updateStatus() {
        switch state {
        case .connecting:
            connecting()
        case .suspend(isConnected: true):
            connected()
        case .suspend(isConnected: false):
            noDeviceStatus()
        }
    }
    
    private func connecting() {
        indicator.isHidden = true
        self.backgroundColor = Colors.red4
        animationView.play()
        animationView.isHidden = false
        connectingLabel.isHidden = false
        noDeviceLabel.isHidden = true
        restoreBtn.isHidden = true
        batteryView.isHidden = true
        showInfoBtn.isHidden = true
    }
    
    private func noDeviceStatus() {
        indicator.isHidden = true
        self.backgroundColor = Colors.red4
        animationView.pause()
        animationView.isHidden = true
        connectingLabel.isHidden = true
        noDeviceLabel.isHidden = false
        restoreBtn.isHidden = false
        batteryView.isHidden = true
        showInfoBtn.isHidden = true
    }
    
    private func connected() {
        indicator.isHidden = false
        self.backgroundColor = UIColor.colorWithHexString(hexColor: "4a5cca")
        animationView.pause()
        animationView.isHidden = true
        connectingLabel.isHidden = true
        noDeviceLabel.isHidden = true
        restoreBtn.isHidden = true
        batteryView.isHidden = false
        showInfoBtn.isHidden = false
        //batteryView.power = BLEManagerClass.shared.bleManager.battery
    }
    
}
