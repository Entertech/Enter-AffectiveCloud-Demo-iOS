//
//  CheckTagViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/12/10.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import SVProgressHUD
import EnterAffectiveCloud
import HandyJSON

@objc
protocol ShowReportDelegate {
    func showReport(db: DBMeditation)
}

struct RecFile: HandyJSON {
    var session_id: String?
    var rec:[CSLabelSubmitJSONModel]?
}

class CheckTagViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: ShowReportDelegate?
    private var reportList: [DBMeditation] = []
    private var isSaveTag = false
    var service: MeditationService?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        navigationItem.title = "检查数据标签"
        navigationController?.setNavigationBarHidden(false, animated: true)
        loadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationName.biodataTagSubmitNotify.observe(sender: self, selector: #selector(submitCallback(_:)))
        NotificationName.kFinishWithCloudServieDB.observe(sender: self, selector: #selector(self.finishWithCloudServiceHandle(_:)))
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setUI() {
        self.view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        submitBtn.layer.cornerRadius = 22
        submitBtn.layer.masksToBounds = true
    }
    
    func loadData() {
        let data = MeditationRepository.query(Preference.clientId)
        if let data = data {
            reportList = data
        }
    }
    


    @IBAction func submitPressed(_ sender: Any) {
        SVProgressHUD.show(withStatus: "正在提交")
        
        // 标签提交
        if let chooseDims = TimeRecord.chooseDim {
            
            var rec: [CSLabelSubmitJSONModel] = []
            for (i,e) in chooseDims.enumerated() {
                let temp = CSLabelSubmitJSONModel()
                if let timeRecord = TimeRecord.time, let startTime = TimeRecord.startTime {
                    let fromTime = timeRecord[i*2].0.timeIntervalSince(startTime)
                    let toTime = timeRecord[i*2+1].0.timeIntervalSince(startTime)
                    temp.st = Int(fromTime)
                    temp.et = Int(toTime)
                }
                var dict: [String: Any] = [:]
                dict.removeAll()
                var tagsName:[String] = []
                if let models = ACTagModel.shared.tagModels {
                    let currentTag = ACTagModel.shared.currentTag
                    if let tags = models[currentTag].tag {
                        for index in 0..<tags.count {
                            tagsName.append(tags[index].name_en!)
                        }
                    }
                }
                for (index,t) in e.enumerated() {
                    dict[tagsName[index]] = t.value!
                }
                temp.tag = dict
                temp.note = []
                rec.append(temp)
                

            }

            if !isSaveTag {
                if let startTime = TimeRecord.startTime {
        
                    let session = RelaxManager.shared.sessionId
                    var recTemp = RecFile()
                    recTemp.session_id = session
                    recTemp.rec = rec
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = Preference.dateFormatter
                    
                    let title = dateFormatter.string(from: startTime)
                    if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let fileUrl = directory.appendingPathComponent(title)
                        //writing
                        do {
                            try recTemp.toJSONString()!.write(to: fileUrl, atomically: false, encoding: .utf8)
                        }
                        catch {
                            /* error handling here */
                        }
                    }
                }
                isSaveTag = true
                
            }

            RelaxManager.shared.tagSubmit(tags: rec)
        }

        SVProgressHUD.dismiss(withDelay: 15) {
            if RelaxManager.shared.isWebSocketConnected {
                SVProgressHUD.showError(withStatus: "连接超时")
            }

        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let chooseDims = TimeRecord.chooseDim {
            return chooseDims.count
        }
        submitBtn.isEnabled = false
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let identifier = "com.enter.check.identifier.r\(index).s\(indexPath.section)"
        let cell: UITableViewCell
        
        if let reuseView = tableView.dequeueReusableCell(withIdentifier: identifier) {
            cell = reuseView
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        cell.accessoryType = .disclosureIndicator
        if let timeRecord = TimeRecord.time, let startTime = TimeRecord.startTime {
            let fromTime = timeRecord[index*2].0.timeIntervalSince(startTime)
            let toTime = timeRecord[index*2+1].0.timeIntervalSince(startTime)
            let fromLeft = Int(fromTime)/60
            let fromRight = Int(fromTime)%60
            let toLeft = Int(toTime)/60
            let toRight = Int(toTime)%60
            cell.textLabel?.text = String(format: "%02d:%02d-%02d:%02d", fromLeft,fromRight,toLeft,toRight)
            
        }
        
        if let chooseDims = TimeRecord.chooseDim {
            var text = ""
            for (i, e) in chooseDims[index].enumerated() {
                text.append(e.name_cn!)
                if i <=  chooseDims.count-1 {
                    text.append(", ")
                }
            }
            cell.detailTextLabel?.text = text
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let reChoose = ReChooseViewController(index: indexPath.row, title: tableView.cellForRow(at: indexPath)!.textLabel!.text!)
        reChoose.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(reChoose, animated: true)
    }
    
    @objc
    func submitCallback(_ noti: Notification) {
        let data = noti.userInfo!["biodataTagSubmit"]
        let model = data as? AffectiveCloudResponseJSONModel
        if let model = model {
            if model.code == 0 {
                SVProgressHUD.showError(withStatus: "上传成功")
                service?.finish()
            } else {
                SVProgressHUD.showError(withStatus: "上传失败, 请用本地导出")
                service?.finish()
            }
        }

    }
    
    /// 情感云结束体验通知处理
    ///
    /// - Parameter notification:
    @objc
    private func finishWithCloudServiceHandle(_ notification: Notification) {
        RelaxManager.shared.close()
        //tag 保存数据库
        var dbModel = TagSaveModel()
        dbModel.id = PersonalInfo.userId?.hashed(.md5)?.uppercased()
        dbModel.userId = PersonalInfo.userId
        dbModel.age = PersonalInfo.age
        dbModel.sex = PersonalInfo.sex == 0 ? "m" : "f"
        let formatter = DateFormatter()
        formatter.dateFormat = Preference.dateFormatter
        dbModel.startTime = formatter.string(from: TimeRecord.startTime!)
        dbModel.chooseDimName = []
        for e in TimeRecord.chooseDim! {
            var temp:[String] = []
            for t in e {
                temp.append(t.name_cn!)
            }
            dbModel.chooseDimName?.append(temp)
        }
        dbModel.time = []
        for e in TimeRecord.time! {
            let str  = formatter.string(from: e.0)
            dbModel.time?.append(str)
        }
        
        TagRepository.create(dbModel.mapperToDBModel()) { (flag) in
            for (i,_) in TimeRecord.chooseDim!.enumerated() {
                TimeRecord.chooseDim![i].removeAll()
            }
            TimeRecord.chooseDim!.removeAll()
            TimeRecord.chooseDim = nil
            
            TimeRecord.startTime = nil
             
            TimeRecord.time?.removeAll()
            TimeRecord.time = nil
            TimeRecord.tagCount  = 0
            
        }
        
        SVProgressHUD.show(withStatus: "生成报表完成")
        DispatchQueue.main.async {
            SVProgressHUD.dismiss(withDelay: 1) {
                self.navigationController?.dismiss(animated: true, completion: {
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
                        let report = ReportViewController()
                        let data = MeditationRepository.query(Preference.clientId)
                        report.reportDB = data?.last
                        report.hidesBottomBarWhenPushed = true
                        UIViewController.currentViewController()!.navigationController?.pushViewController(report, animated: true)
                    }
                })
            }
            
        }
    }

}
