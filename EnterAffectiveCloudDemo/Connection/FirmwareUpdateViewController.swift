//
//  FirmwareUpdateViewController.swift
//  Flowtime
//
//  Created by Enter on 2019/9/6.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import Lottie
import EnterBioModuleBLE

class FirmwareUpdateViewController: UIViewController {
    
    private enum UpdateState: Int {
        case app = 0
        case show = 1
        case faild = 2
        case updating = 3
        case completed = 4
    }

    private var currentState: UpdateState?
    public var stateValue: Int = 0
    public var noteValue: String = ""
    @IBOutlet weak var maskDark: BackgroundView!
    @IBOutlet weak var navigationTitle: UILabel!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var updateNotesLabel: UILabel!
    @IBOutlet weak var updateBtn: UIButton!
    let progressView = AnimationView()
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBtn.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        maskDark.backgroundColor = Colors.maskDark
        updateBtn.setTitleColor(Colors.bluePrimary, for: .normal)
        
        let aView = AnimationView()
        self.view.addSubview(aView)
        self.view.sendSubviewToBack(aView)
        aView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        aView.animation = Animation.named("bg_animation_premium")
        aView.contentMode = .scaleAspectFill
        aView.loopMode = .loop
        aView.play()
        
        self.view.addSubview(progressView)
        self.view.bringSubviewToFront(progressView)
        progressView.snp.makeConstraints {
            $0.left.equalTo(titleImageView.snp.left)
            $0.right.equalTo(titleImageView.snp.right)
            $0.top.equalTo(titleImageView.snp.top)
            $0.bottom.equalTo(titleImageView.snp.bottom)
        }
        progressView.animation = Animation.named("loading")
        progressView.contentMode = .scaleAspectFill
        progressView.loopMode = .loop
        setUpdateViewState(state: stateValue)
        setNotes(note: noteValue)
        NotificationName.dfuStateChanged.observe(sender: self, selector: #selector(didFirmwareUpdateStateChanged(_:)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationName.dfuStateChanged.remove(sender: self)
    }
    
    public func setNotes(note: String) {
        let attributedText = NSMutableAttributedString(string: note)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0
        style.lineBreakMode = .byWordWrapping
        attributedText.addAttribute(kCTParagraphStyleAttributeName as NSAttributedString.Key, value: style, range: NSMakeRange(0, attributedText.length))
        updateNotesLabel.attributedText = attributedText
    }

    @IBAction func dismisBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateBtnTouched(_ sender: Any) {
        switch currentState! {
        
        case .app:
            //跳转appstore
            let urlString = "https://apps.apple.com/app/id1488292024"
            let url = URL(string: urlString)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        case .show:
            firmwareUpdate()
            setUpdateViewState(state: 3)
            break
        case .faild:
            self.dismiss(animated: true, completion: nil)
        case .updating:
            break
        case .completed:
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /// 设置升级状态
    ///
    /// - Parameter state: 按照枚举UpdateState对应的数字
    public func setUpdateViewState(state: Int) {

        updateBtn.isHidden = true
        progressView.isHidden = true
        if progressView.isAnimationPlaying {
            progressView.stop()
        }
        titleImageView.isHidden = false
        closeBtn.isEnabled  =  true
        currentState = UpdateState(rawValue: state)
        switch state {
        case UpdateState.app.rawValue:
            navigationTitle.text = "应用更新"
            titleLabel.text = "更新内容?"
            titleImageView.image = #imageLiteral(resourceName: "img_update_logo")
            updateNotesLabel.textAlignment = .left
            updateBtn.isHidden = false
        case UpdateState.show.rawValue:
            navigationTitle.text = "固件升级"
            titleLabel.text = "更新内容?"
            titleImageView.image = UIImage(named: "img_update_cloud")
            updateNotesLabel.textAlignment = .left
            updateBtn.isHidden = false
            closeBtn.isHidden = true
        case UpdateState.faild.rawValue:
            titleImageView.image = #imageLiteral(resourceName: "img_update_wrong")
            titleLabel.text = "升级失败"
            setNotes(note: "请返回上一步重新连接设备尝试。")
            updateNotesLabel.textAlignment = .center
            closeBtn.isHidden = false
        case UpdateState.updating.rawValue:
            setNotes(note: "升级过程需要花费一些时间，请将您的设备靠近手机。")
            titleLabel.text = "Updating"
            closeBtn.isEnabled = true
            titleImageView.isHidden = true
            progressView.isHidden = false
            closeBtn.isHidden = true
            progressView.play()
            updateNotesLabel.textAlignment = .center
        case UpdateState.completed.rawValue:
            setNotes(note: "升级完成，设备将会重启。")
            titleLabel.text = "Update Completed"
            closeBtn.isHidden = false
            titleImageView.image = #imageLiteral(resourceName: "icon_lesson_learned")
            updateNotesLabel.textAlignment = .center
            
        default:
            break
        }

    }
    
    
    private func firmwareUpdate() {
        let url = FTFileManager.shared.firmwareTempDirectory("firmware.zip")
        do {
            try BLEService.shared.bleManager.dfu(fileURL: url)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK - STATE NOTIFICATION
    @objc private func didFirmwareUpdateStateChanged(_ notification: Notification) {
        if let info = notification.userInfo,
            let state = info[NotificationKey.dfuStateKey.rawValue] as? EnterBioModuleBLE.DFUState {
 
            switch state {
                
            case .none:
                break
            case .prepared:
                break
            case .upgrading(let progress):
                break
            case .succeeded:
                BLEService.shared.bleManager.disconnect()
                setUpdateViewState(state: 4)
            case .failed:
                setUpdateViewState(state: 2)
   
            }
        }
    
    }
    
}
