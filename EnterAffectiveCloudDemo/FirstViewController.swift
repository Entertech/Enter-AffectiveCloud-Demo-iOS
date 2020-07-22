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
import AVKit
import AVFoundation

class FirstViewController: UIViewController {

    @IBOutlet weak var connectionBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    private var playerItem: AVPlayerItem?
    private var player: AVPlayer?
    var bIsShowedAppUpdate = false
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        DispatchQueue.global().async {
            SyncManager.shared.sync()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setConnectionButtonImage()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(playerDidFinishPlaying),
        name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
        object: playerItem)
        
        player?.play()
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        player?.pause()
    }

    func setUI() {
        self.tabBarController?.tabBar.backgroundImage = UIImage()
        self.tabBarController?.tabBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.unselectedItemTintColor = .lightGray
        startBtn.layer.cornerRadius = 22.5
        startBtn.layer.masksToBounds = true
        
        if let filePath = Bundle.main.path(forResource: "Boat", ofType: "mp4") {
            let videoURL = URL(fileURLWithPath: filePath)
            playerItem = AVPlayerItem(url: videoURL)
            player = AVPlayer(playerItem: playerItem)
            let playerLayer = AVPlayerLayer(player: player!)
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = self.view.bounds
            self.view.layer.insertSublayer(playerLayer, at: 0)
            player?.volume = 0
            player?.play()
        }
    }

    @IBAction func showMeditation(_ sender: Any) {
        if BLEService.shared.bleManager.state == .disconnected {
            SVProgressHUD.showError(withStatus: "请先连接设备")
        } else {
            let controller = ChooseTimerViewController()
            let nv = UINavigationController(rootViewController: controller)
            nv.modalPresentationStyle = .fullScreen
            nv.isNavigationBarHidden = true
            self.present(nv, animated: true, completion: nil)
        }
    }
    @IBAction func connectBLE(_ sender: Any) {
        if Preference.haveFlowtimeConnectedBefore {
            let controller = DeviceStatusViewController()
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = FlowtimeIntroductionViewController()
            controller.modalPresentationStyle = .fullScreen
            let navi = UINavigationController(rootViewController: controller)
            navi.modalPresentationStyle = .fullScreen
            //self.navigationController?.pushViewController(controller, animated: true)
            self.present(navi, animated: true, completion: nil)
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
    
    //视频播放完毕响应
    @objc
    func playerDidFinishPlaying() {
        if let player = self.player {
            player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
            player.play()
        }
        
    }

}

