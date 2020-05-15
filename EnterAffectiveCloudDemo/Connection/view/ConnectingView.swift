//
//  ConnectingView.swift
//  Naptime
//
//  Created by HyanCat on 21/11/2017.
//  Copyright © 2017 EnterTech. All rights reserved.
//

import Foundation
import Lottie

class ConnectingView: BaseView {

    enum State {
        case connecting
        case suspend(isConnected: Bool)
    }

    var state: State = .suspend(isConnected: false) {
        didSet {
            updateStatus()
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setup() {
        super.setup()
        self.addSubview(_animationView)
        self.addSubview(_tipLabel)
        self.addSubview(_reconnectButton)
        
        
        _animationView.loopMode = .loop
        _animationView.animationSpeed = 0.75
        _animationView.contentMode = .scaleAspectFit
        
        _tipLabel.textColor = UIColor.white
        
        _reconnectButton.setTitle("Reconnect", for: .normal)
        _reconnectButton.setTitleColor(.black, for: .normal)
        _reconnectButton.backgroundColor = .white
        _reconnectButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        _reconnectButton.layer.cornerRadius = 15
        
        _reconnectButton.isHidden = true
        _reconnectButton.addTarget(self, action: #selector(handleReconnectButtonTouched(_:)), for: .touchUpInside)
    }

    override func layout() {
        super.layout()
        _animationView.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(0)
            $0.width.equalTo(ceil(100/1.5))
            $0.height.equalTo(180/1.5)
        }
        _tipLabel.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(_animationView.snp.bottom).offset(8)
        }
        _reconnectButton.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(_animationView.snp.bottom).offset(8)
            $0.width.equalTo(100)
            $0.height.equalTo(32)
        }
    }

    @objc
    private func handleReconnectButtonTouched(_ sender: UIButton) {
        if BluetoothContext.shared.manager.state != .poweredOn {
            showAlert()
            return
        }

        // reconnect bluetooth
        do {
            try BLEService.shared.bleManager.scanAndConnect { (flag) in
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
    
    private func showAlert() {
        let alert = UIAlertController(title: "Bluetooth is off",
                                      message: "Open Bluetooth in Settings to use Flowtime",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        alert.present()
    }

    func resumeIfNeeded() {
        switch state {
        case .connecting:
            _animationView.play()
        default: break
        }
    }
    
    func stopAnimation() {
        _animationView.stop()
    }

    func updateStatus() {
        switch state {
        case .connecting:
            _animationView.isHidden = false
            _animationView.play()
            _tipLabel.text = "Connecting ..."
            _reconnectButton.isHidden = true
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
                self._tipLabel.transform = CGAffineTransform.identity
                self._tipLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
                self._tipLabel.alpha = 1.0
            })
        case .suspend(isConnected: true):
            _animationView.isHidden = true
            _animationView.pause()
            _tipLabel.text = "Connected"
            _reconnectButton.isHidden = true
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
                self._tipLabel.transform = CGAffineTransform.identity
                self._tipLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
                self._tipLabel.alpha = 1.0
            })
        case .suspend(isConnected: false):
            _animationView.pause()
            _animationView.isHidden = true
            _tipLabel.text = "No device found"
            _reconnectButton.isHidden = false
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
                self._tipLabel.transform = CGAffineTransform(translationX: 0, y: -100)
                self._tipLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            })
        }
    }

    private let _animationView: AnimationView = AnimationView(name: "连接中")

    private let _tipLabel: UILabel = UILabel()

    private let _reconnectButton = UIButton()
}
