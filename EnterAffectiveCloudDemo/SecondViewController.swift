//
//  SecondViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/12.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private var reportList: [DBMeditation] = []
    private var tableviewOffset = 52
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelectionDuringEditing = true
        //tableView.contentInset = UIEdgeInsets(top: CGFloat(tableviewOffset), left: 0, bottom: 0, right: 0)
        //tableView.setContentOffset(CGPoint(x: 0, y: -tableviewOffset), animated: false)
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "分析报告"
        let rightBtn = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(deleteCell(sender:)))
        navigationItem.setRightBarButton(rightBtn, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        loadData()
    }
    
    func loadData() {
        let data = MeditationRepository.query(Preference.clientId)
        if let data = data {
            reportList = data
        }
        tableView.reloadData()
    }
    
    
    @objc
    func deleteCell(sender: UIBarButtonItem) {
        if !tableView.isEditing {
            sender.title = "确定"
            tableView.setEditing(true, animated: true)
        } else {
            let data = MeditationRepository.query(Preference.clientId)
            let len = data?.count ?? 0
            do  {
                try tableView.indexPathsForSelectedRows?.forEach({ (indexPath) in
                    reportList.remove(at: len-indexPath.row-1)
                    if let data = data {
                        let record = data[len-indexPath.row-1]
                        do {
                            try MeditationRepository.delete(record.id)
                        } catch {
                            throw error
                        }
                        
                    }
                })
            } catch {
            }
            
            tableView.reloadData()
            sender.title = "编辑"
            tableView.setEditing(false, animated: true)
        }
    }
    
    let cellColors: [UIColor] = [#colorLiteral(red: 0.7803921569, green: 1, blue: 0.8941176471, alpha: 1), #colorLiteral(red: 0.8980392157, green: 0.9176470588, blue: 0.968627451, alpha: 1), #colorLiteral(red: 0.9921568627, green: 0.9450980392, blue: 0.9176470588, alpha: 1), #colorLiteral(red: 1, green: 0.9058823529, blue: 0.9019607843, alpha: 1)]
    let cellLiteralColor: [UIColor] = [#colorLiteral(red: 0.3882352941, green: 0.4980392157, blue: 0.4470588235, alpha: 1), #colorLiteral(red: 0.3333333333, green: 0.3568627451, blue: 0.4980392157, alpha: 1), #colorLiteral(red: 0.4980392157, green: 0.4470588235, blue: 0.368627451, alpha: 1), #colorLiteral(red: 0.4980392157, green: 0.3490196078, blue: 0.3764705882, alpha: 1)]
    let cellBgImages: [[UIImage]] = [[#imageLiteral(resourceName: "img_statistics_green2"), #imageLiteral(resourceName: "img_statistics_green1"), #imageLiteral(resourceName: "img_statistics_green3")],
                                     [#imageLiteral(resourceName: "img_statistics_blue3"), #imageLiteral(resourceName: "img_statistics_blue2"), #imageLiteral(resourceName: "img_statistics_blue1")],
                                     [#imageLiteral(resourceName: "img_statistics_yellow1"), #imageLiteral(resourceName: "img_statistics_yellow3"), #imageLiteral(resourceName: "img_statistics_yellow2")],
                                     [#imageLiteral(resourceName: "img_statistics_red1"), #imageLiteral(resourceName: "img_statistics_red2"), #imageLiteral(resourceName: "img_statistics_red3")]]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reportList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "record_reuse_id"
        let cell: ReportListTableViewCell
        if let reuseView = tableView.dequeueReusableCell(withIdentifier: identifier) as? ReportListTableViewCell {
            cell = reuseView
        } else {
            cell = ReportListTableViewCell(reuseIdentifier: identifier)
        }
        let record = self.reportList[reportList.count-indexPath.row-1]
        let startTime = Date.date(dateString: record.startTime, custom: "yyyy-MM-dd HH:mm:ss")
        let finishTime = Date.date(dateString: record.finishTime, custom: "yyyy-MM-dd HH:mm:ss")
        cell.backgroundColor = .white
        cell.weekLabel.text = startTime!.string(custom: "yyyy.MM.dd EEE", local: Locale.init(identifier: "zh_CN"))
        cell.minuteLabel.text = record.tagId//"\(Int(finishTime!.timeIntervalSince(startTime!)/60)) 分钟"
        cell.fromToLabel.text = "\(startTime!.string(custom: "hh:mma"))~\(finishTime!.string(custom: "hh:mma"))"
        let colorIndex = indexPath.row % cellColors.count
        cell.cellColor = cellColors[colorIndex]
        cell.literalColor = cellLiteralColor[colorIndex]
        cell.imageview.image = cellBgImages[colorIndex].randomElement()
        cell.isMeditationRecord = record.reportPath != nil || record.hrAverage != 0

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            let record = self.reportList[reportList.count-indexPath.row-1]
            let report = ReportViewController()
            report.reportDB = record
            report.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(report, animated: true)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if !tableView.isEditing {
            return .none
        } else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

