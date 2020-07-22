//
//  ReminderViewController.swift
//  Flowtime
//
//  Created by Enter on 2019/9/3.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import UserNotifications

class ReminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let switchKit = UISwitch()
    let timerPicker = UIDatePicker()
    var bgView: UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setTimerPickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bgView?.isHidden = true
        self.view.backgroundColor = Colors.bg1
        tableView.backgroundColor = Colors.bg1
        tableView.reloadData()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if Preference.reminder {
            return 2
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "com.enter.reminder.identifier.r\(indexPath.row).s\(indexPath.section)"
        let cell: UITableViewCell
        if let reuseView = tableView.dequeueReusableCell(withIdentifier: identifier) {
            cell = reuseView
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        cell.selectionStyle = .none
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell.accessoryType = .none
            cell.textLabel?.text = "提醒"
            switchKit.isOn = Preference.reminder
            switchKit.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            cell.addSubview(switchKit)
            switchKit.snp.makeConstraints{
                $0.right.equalToSuperview().offset(-20)
                $0.centerY.equalToSuperview()
            }
        case (1, 0):
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "重复"
            switch Preference.reminderDays {
            case 0x60:
                cell.detailTextLabel?.text = "周末"
            case 0x1F:
                cell.detailTextLabel?.text = "周末"
            case 0x7F:
                cell.detailTextLabel?.text = "每日"
            default:
                let day = Preference.reminderDays
                let sun = (day >> 0) & 1 == 1 ? "日" : ""
                let mon = (day >> 1) & 1 == 1 ? "一" : ""
                let Tues = (day >> 2) & 1 == 1 ? "二" : ""
                let wed = (day >> 3) & 1 == 1 ? "三" : ""
                let thur = (day >> 4) & 1 == 1 ? "四" : ""
                let fri = (day >> 5) & 1 == 1 ? "五" : ""
                let sat = (day >> 6) & 1 == 1 ? "六" : ""
                
                cell.detailTextLabel?.text = "\(sun)\(mon)\(Tues)\(wed)\(thur)\(fri)\(sat)"
            }
        case (1, 1):
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "Timer"
            let settingDate = Date(timeIntervalSince1970: TimeInterval(Preference.remindTime))
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
            dateFormatter.dateFormat = "h:mm a"
            let dateString = dateFormatter.string(from: settingDate)
            cell.detailTextLabel?.text = dateString
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            let weekVC = WeekViewController()
            self.navigationController?.pushViewController(weekVC, animated: true)
        case (1, 1):
            bgView?.isHidden = false
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section  == 0 {
            return "同意应用发送通知提醒你定期训练。"
        } else {
            return nil
        }
    }
    
    
    // MARK: - switch
    
    @objc
    func switchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            let userNotificaiton = UNUserNotificationCenter.current()
            userNotificaiton.getNotificationSettings { (settings) in
                
                if settings.authorizationStatus == .notDetermined { // 没有决定权限
                    
                    let settingAction = UIAlertAction(title: "确定", style: .default, handler: { (alert) in
                        userNotificaiton.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {[weak self] (success, error) in
                            guard let self = self else {return}
                            DispatchQueue.main.async {
                                if success {
                                    UIApplication.shared.registerForRemoteNotifications()
                                    Preference.reminder = sender.isOn
                                    self.tableView.reloadData()
                                } else {
                                    sender.isOn = false
                                }
                            }
                        })
                    })
                    DispatchQueue.main.async {
                        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { alert in
                            sender.isOn = false
                        })
                        let alert = UIAlertController.init(title: "通知权限", message: "心流需要通知权限来通知您进行定期训练。", preferredStyle: .alert)
                        alert.addAction(settingAction)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                } else if settings.authorizationStatus == .authorized { //授权了
                    DispatchQueue.main.async {
                        Preference.reminder = sender.isOn
                        self.tableView.reloadData()
                    }
                    
                } else if settings.authorizationStatus == .denied { //拒绝权限
                    DispatchQueue.main.async {
                        sender.isOn = false
                        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                        let settingAction = UIAlertAction(title: "去设置", style: .default, handler: { (alert) in
                            if let url  =  URL(string: UIApplication.openSettingsURLString) {
                                if UIApplication.shared.canOpenURL(url) {
                                    let options:[UIApplication.OpenExternalURLOptionsKey : Any] = [:]
                                    UIApplication.shared.open(url, options: options, completionHandler: nil)
                                }
                            }
                        })
                        let alert = UIAlertController.init(title: "无通知权限", message: "心流需要通知权限来通知您进行定期训练。您可以在系统设置里设置。", preferredStyle: .alert)
                        alert.addAction(settingAction)
                        alert.addAction(cancelAction)
                        //AlertAction.shared.showAlertWith(self, title: "No Notification Permission", message: "Flowtime need your notificaiton permission to send you a reminder. You can configured it in Settings", actions: cancelAction,settingAction)
                        self.present(alert, animated: true, completion: nil )
                    }
                    
                }
            }
        } else {
            ReminderService.initReminder() // 清除闹钟
            Preference.reminder = sender.isOn
            self.tableView.reloadData()
        }
        
        
    }
    
    // MARK: - picker
    private func setTimerPickerView() {
        if let bgView = self.bgView {
            bgView.isHidden = false
        } else {
            bgView = UIView()
            // 黑色背景
            bgView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            self.view.addSubview(bgView!)
            bgView?.snp.makeConstraints{
                $0.left.right.top.equalToSuperview()
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
            
            // 时间选择器
            timerPicker.datePickerMode = .time
            timerPicker.backgroundColor = Colors.bgZ1
            timerPicker.locale = NSLocale.current
            timerPicker.countDownDuration = TimeInterval(Preference.remindTime)
            bgView?.addSubview(timerPicker)
            timerPicker.snp.makeConstraints{
                $0.left.right.bottom.equalToSuperview()
                $0.height.equalTo(210)
            }
            
            // 菜单栏
            let menu = UIView()
            bgView?.addSubview(menu)
            menu.backgroundColor = Colors.bg1
            menu.snp.makeConstraints{
                $0.left.right.equalToSuperview()
                $0.bottom.equalTo(timerPicker.snp.top).offset(-1)
                $0.height.equalTo(44)
            }
            
            let cancelBtn = UIButton()
            cancelBtn.setTitle("取消", for: .normal)
            cancelBtn.setTitleColor(Colors.btn1, for: .normal)
            cancelBtn.addTarget(self, action: #selector(cancelTouchupInside), for: .touchUpInside)
            menu.addSubview(cancelBtn)
            cancelBtn.snp.makeConstraints {
                $0.left.equalToSuperview().offset(16)
                $0.centerY.equalToSuperview()
            }
            
            let okBtn = UIButton()
            okBtn.setTitle("好的", for: .normal)
            okBtn.setTitleColor(Colors.btn1, for: .normal)
            okBtn.addTarget(self, action: #selector(okTouchupInside), for: .touchUpInside)
            menu.addSubview(okBtn)
            okBtn.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-16)
                $0.centerY.equalToSuperview()
            }
            
            let title = UILabel()
            title.text = "提醒时间"
            title.textAlignment = .center
            menu.addSubview(title)
            title.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.centerX.equalToSuperview()
            }
        }
        
    }
    @IBAction func backTouchUpInside(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func cancelTouchupInside() {
        self.bgView?.isHidden = true
    }
    
    @objc
    private func okTouchupInside() {
        let pickerInterval = Int(timerPicker.countDownDuration)
        Preference.remindTime = pickerInterval
        let hour = pickerInterval / 60 / 60
        let minute = pickerInterval / 60 % 60
        ReminderService.initReminder()
        let weekDay = Preference.reminderDays
        for i in (0...6) {
            if (weekDay >> i) & 1 == 1 {
                let components = DateComponents(hour: hour, minute: minute, weekday: (i+1))
                ReminderService.registReminder(title: "心流提醒", body: "打开应用开始今天的训练吧。", repeats: true, dateComponents: components)
            }
        }
        
        self.bgView?.isHidden = true
        self.tableView.reloadData()
    }
}
