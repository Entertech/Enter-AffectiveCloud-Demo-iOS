//
//  ThirdViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/17.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import SafariServices
import HealthKit
import MessageUI
import SVProgressHUD

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.title = "设置"
        
        self.view.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9764705882, alpha: 1)
        tableView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9607843137, blue: 0.9764705882, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        setupIconView()
        addHeaderView()
        addFooterCopyRightView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    let sectionList = ["设置","","支持",""]
    let cellIconList = [[#imageLiteral(resourceName: "icon_me_reminder"),#imageLiteral(resourceName: "icon_apple_health")], [#imageLiteral(resourceName: "icon_me_appstore")],[#imageLiteral(resourceName: "icon_me_fb"),#imageLiteral(resourceName: "Stockholm-help"), #imageLiteral(resourceName: "Stockholm-Terms of Services"), #imageLiteral(resourceName: "Stockholm-Privacy")]]
    let cellTitlelist = [["提醒", "Apple健康"],["给我们评价"],["反馈问题","帮助中心","使用条款","隐私政策"], ["退出登录"]]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitlelist[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "com.enter.me.identifier.r\(indexPath.row).s\(indexPath.section)"
        let secIndex = indexPath.section
        let rowIndex = indexPath.row
        let cell: UITableViewCell
        
        if let reuseView = tableView.dequeueReusableCell(withIdentifier: identifier) {
            cell = reuseView
        } else {
            if secIndex < 3 {
                cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
            } else if secIndex == 3{
                cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
            } else {
                cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
            }
            
        }
        if secIndex < 3 {
            cell.imageView?.image = cellIconList[secIndex][rowIndex]
            cell.textLabel?.text = cellTitlelist[secIndex][rowIndex]
            if secIndex == 0 && rowIndex == 1 {
                cell.accessoryType = .none
                //为了防止swich重复加载
                var isSwitchInView = false
                for e in cell.subviews {
                    if e.isKind(of: UISwitch.classForCoder()) {
                        isSwitchInView = true
                        break
                    }
                }
                if !isSwitchInView {
                    
                    switchKit.isOn = Preference.healthKit
                    switchKit.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
                    cell.addSubview(switchKit)
                    switchKit.snp.makeConstraints{
                        $0.right.equalToSuperview().offset(-20)
                        $0.centerY.equalToSuperview()
                    }
                }
            } else {
                cell.accessoryType = .disclosureIndicator
            }
            
        } else {
            cell.selectionStyle = .none
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.text = cellTitlelist[secIndex][rowIndex]
            cell.textLabel?.textColor = #colorLiteral(red: 1, green: 0.4, blue: 0.5098039216, alpha: 1)
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let reminder = ReminderViewController()
            reminder.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(reminder, animated: true)
        case (1, 0):
            let appPath = "https://apps.apple.com/app/id1515849798?action=write-review"
            let appUrl = URL(string: appPath)
            UIApplication.shared.open(appUrl!, options: [:], completionHandler: nil)
        case (2, 0):
            sendEmail()
        case (2, 1):
            presentSafari(FTRemoteConfig.shared.getConfig(key: .help)!)
        case (2, 2):
            presentSafari(FTRemoteConfig.shared.getConfig(key: .items)!)
        case (2, 3):
            presentSafari(FTRemoteConfig.shared.getConfig(key: .privacy)!)
        
            
        case (3, 0):
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let action =  UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { (action) in
                TokenHandle.shared.logout()
                self.tabBarController?.dismiss(animated: true, completion: nil)
            }
            var alert: UIAlertController?
            if UIDevice.current.userInterfaceIdiom == .pad {
                alert = UIAlertController.init(title: "提示", message: "退出不会删除数据。你依然可以使用此账号登录。", preferredStyle: .actionSheet)
            } else {
                alert = UIAlertController.init(title: "提示", message: "退出不会删除数据。你依然可以使用此账号登录。", preferredStyle: .actionSheet)
            }
            alert?.addAction(cancel)
            alert?.addAction(action)
            self.present(alert!, animated: true, completion: nil)

        default:
            presentSafari(FTRemoteConfig.shared.getConfig(key: .help)!)
        }
    }
    
    
    let switchKit = UISwitch()
    private let iconView = UIView()
    private func setupIconView() {
        switchKit.tintColor = Colors.bluePrimary
        switchKit.onTintColor = Colors.bluePrimary
        
        self.view.addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(148)
        }
        let userModel = User.default
        let imageview = UIImageView()
        imageview.layer.cornerRadius = 28
        imageview.layer.masksToBounds = true
        if userModel.socialType == SocialType.apple {
            imageview.image = #imageLiteral(resourceName: "icon_people")
        } else {
            let image = UIImage.loadImage(imageName: "\(userModel.name)_\(userModel.userId)")
            imageview.image = image
        }

        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = userModel.name
        label.textColor = Colors.textLv1
        let facebookIcon = UIImageView()
        switch userModel.socialType {
        case SocialType.wechat:
            facebookIcon.image = #imageLiteral(resourceName: "icon_auth_wechat-1")
        case SocialType.apple:
            facebookIcon.image = #imageLiteral(resourceName: "icon_apple")
        default:
            break
        }
        self.iconView.addSubview(imageview)
        self.iconView.addSubview(label)
        self.iconView.addSubview(facebookIcon)
        self.iconView.backgroundColor = Colors.bgZ1

        imageview.snp.makeConstraints {
            $0.left.equalTo(24)
            $0.bottom.equalTo(-24)
            $0.width.height.equalTo(56)
        }

        label.snp.makeConstraints {
            $0.left.equalTo(imageview.snp.right).offset(12)
            $0.right.equalTo(-20)
            $0.top.equalTo(imageview.snp.top)
            $0.height.equalTo(24)
        }

        facebookIcon.snp.makeConstraints {
            $0.left.equalTo(label.snp.left)
            $0.bottom.equalTo(imageview.snp.bottom)
            $0.width.height.equalTo(24)
        }
    }

    private func addHeaderView() {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width:self.view.bounds.width, height: 100))
        let barView = UIView()
        barView.backgroundColor = Colors.yellow4
        barView.layer.cornerRadius = 8
        barView.layer.shadowColor = UIColor.black.cgColor
        barView.layer.shadowOpacity = 0.2
        barView.layer.shadowOffset = CGSize(width: 0,height: 10)
        barView.layer.shadowRadius = 8
        view.addSubview(barView)
        barView.snp.makeConstraints {
            $0.center.equalTo(view.snp.center)
            $0.height.equalTo(54)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        
        let label = UILabel()
        label.text = "Flowtime头环"
        label.textColor = Colors.yellow2
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        barView.addSubview(label)
        label.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "img_introduce")
        barView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.width.equalTo(74)
            $0.height.equalTo(28)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-44)
        }
         
        let indicator = UIImageView()
        indicator.image = UIImage(named: "icon_me_indicator")
        barView.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.right.equalTo(-24)
            $0.centerY.equalToSuperview()
        }
        
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(headbandAction), for: .touchUpInside)
        barView.addSubview(button)
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.tableHeaderView = view
    }
    
    private func addFooterCopyRightView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 72))
        let idLabel = UILabel()
        idLabel.text = "ID: \(Preference.userID)"
        idLabel.textColor = Colors.textLv2
        idLabel.font = UIFont.systemFont(ofSize: 11)
        idLabel.textAlignment = .center
        view.addSubview(idLabel)
        
        let versionLabel = UILabel()
        versionLabel.text = Preference.appVersion
        versionLabel.textColor = Colors.textLv2
        versionLabel.font = UIFont.systemFont(ofSize: 11)
        versionLabel.textAlignment = .center

        view.addSubview(versionLabel)
        self.tableView.tableFooterView = view

        let copyrightLabel = UILabel()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy"
        let currentYear = dateFormat.string(from: Date())
        let copyright = "© 2020-" + currentYear + " Entertech Ltd."
        copyrightLabel.text = copyright
        copyrightLabel.textColor = Colors.textLv2
        copyrightLabel.font = UIFont.systemFont(ofSize: 11)
        copyrightLabel.textAlignment = .center
        
        view.addSubview(copyrightLabel)
        
        idLabel.snp.makeConstraints {
            $0.bottom.equalTo(copyrightLabel.snp.top).offset(-4)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(16)
            $0.width.equalTo(80)
        }
        versionLabel.snp.makeConstraints {
            $0.bottom.equalTo(idLabel.snp.top).offset(-4)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(16)
            $0.width.equalTo(80)
        }
        copyrightLabel.snp.makeConstraints {
            $0.bottom.equalTo(-14)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(16)
            $0.width.equalTo(164)
        }
    }
    
    /// Safari 显示网页
    private func presentSafari(_ defaultKey: String) {
        if let url = URL(string: defaultKey) {
            let sf = SFSafariViewController(url: url)
            present(sf, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - action
    @objc
    func headbandAction(_ sender: UIButton) {
        if Preference.haveFlowtimeConnectedBefore {
            let controller = DeviceStatusViewController()
            controller.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = FlowtimeIntroductionViewController()
            let nv = UINavigationController(rootViewController: controller)
            nv.modalPresentationStyle = .fullScreen
            nv.isNavigationBarHidden = true
            self.present(nv, animated: true, completion: nil)
        }
    }
    
    @objc
    private func switchValueChanged(_ sender: UISwitch) {
        Preference.healthKit = sender.isOn
        if sender.isOn {
            healthStoreFunc()
        }
    }
    
    ///healthkit
    public func healthStoreFunc() {
        
        let healthStore = HKHealthStore()
        let hkType = HKObjectType.categoryType(forIdentifier: .mindfulSession)!
        if healthStore.authorizationStatus(for: hkType) == .notDetermined { //请求权限
            let action = UIAlertAction(title: "设置", style: .default) { (alert) in
                let typesToWrite = Set([hkType])
                let typesToRead = Set([hkType])
                healthStore.requestAuthorization(toShare: typesToWrite, read: typesToRead, completion: {
                    (success, error) in
                })
            }
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            let alert = UIAlertController.init(title: "提示", message: "将冥想时间记录到Apple健康里。", preferredStyle: .alert)
            alert.addAction(cancel)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        } else if healthStore.authorizationStatus(for: hkType) == .sharingDenied {
            self.switchKit.isOn = false
            let goToAction = UIAlertAction(title: "好的", style: .default, handler: { (action) in
            })
            
            let alert = UIAlertController.init(title: "无健康权限", message: "您可以在 设置-隐私-健康-心流 里设置", preferredStyle: .alert)
            alert.addAction(goToAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    ///email 反馈
    func sendEmail() {
        if MFMailComposeViewController.canSendMail()  {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["customer@entertech.cn"])
            var systemInfo = utsname()
            uname(&systemInfo)
            let platform  = withUnsafePointer(to: &systemInfo.machine.0) { (ptr) in
                return String(cString: ptr)
            }
            mail.setSubject("心流反馈")
            mail.setMessageBody("\n\n\n \(UIDevice.current.systemName) \(UIDevice.current.systemVersion) \(platform) \(Bundle.main.infoDictionary!["CFBundleDisplayName"] ?? "Flowtime") \(Bundle.main.infoDictionary!["CFBundleShortVersionString"] ?? "0.0.1")(\(Bundle.main.infoDictionary!["CFBundleVersion"] ?? "1")) ID:\(Preference.userID)", isHTML: false)
            //mail.setSubject("Feedback from \(UIDevice.current.systemName) \(UIDevice.current.systemVersion) \(platform)")
        
            present(mail, animated: true, completion: nil)
        } else {
            SVProgressHUD.showInfo(withStatus: "请发邮件给customer@entertech.cn")
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)

    }

}
