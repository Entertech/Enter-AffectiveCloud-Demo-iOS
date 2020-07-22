//
//  WeekViewController.swift
//  Flowtime
//
//  Created by Enter on 2019/9/3.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class WeekViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = Colors.bg1
        self.tableView.backgroundColor = Colors.bg1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "闹钟提醒"
    }
    
    // 一周7天
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "com.enter.week.identifier.r\(indexPath.row).s\(indexPath.section)"
        let cell: UITableViewCell
        if let reuseView = tableView.dequeueReusableCell(withIdentifier: identifier) {
            cell = reuseView
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        if (Preference.reminderDays >> indexPath.row) & 1 != 0  {
            cell.accessoryType = .checkmark
        } else  {
            cell.accessoryType = .none
        }
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            cell.textLabel?.text = "日"
        case (0, 1):
            cell.textLabel?.text = "一"
        case (0, 2):
            cell.textLabel?.text = "二"
        case (0, 3):
            cell.textLabel?.text = "三"
        case (0, 4):
            cell.textLabel?.text = "四"
        case (0, 5):
            cell.textLabel?.text = "五"
        case (0, 6):
            cell.textLabel?.text = "六"
        
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        let chooseDays = Preference.reminderDays
        Preference.reminderDays = chooseDays^(1<<(row))
        tableView.reloadData()
    }
}

