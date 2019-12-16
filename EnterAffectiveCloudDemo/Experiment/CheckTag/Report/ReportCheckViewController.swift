//
//  ReportCheckViewController.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/12/11.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

class ReportCheckViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()
    var db: DBTagSave?
    var startTime: String?
    init(data: String) {
        super.init(nibName: nil, bundle: nil)
        startTime = data
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "检查数据标签"
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.view.backgroundColor = .white
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        db = TagRepository.findSt(self.startTime!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let db  = self.db {
            return db.chooseDimName.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let identifier = "com.enter.check.identifier.r\(index).s\(indexPath.section)"
        let cell: UITableViewCell
        
        if let reuseView = tableView.dequeueReusableCell(withIdentifier: identifier) {
            cell = reuseView
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        cell.accessoryType = .disclosureIndicator
        if let query = db {
            let formatter = DateFormatter()
            formatter.dateFormat = Preference.dateFormatter
            let from = formatter.date(from: query.time[row*2])!
            let to = formatter.date(from: query.time[row*2+1])!
            let startTime = formatter.date(from: query.startTime)!
            let fromTime = from.timeIntervalSince(startTime)
            let toTime = to.timeIntervalSince(startTime)
            let fromLeft = Int(fromTime)/60
            let fromRight = Int(fromTime)%60
            let toLeft = Int(toTime)/60
            let toRight = Int(toTime)%60
            cell.textLabel?.text = String(format: "%02d:%02d-%02d:%02d", fromLeft,fromRight,toLeft,toRight)

            let chooseDims = query.chooseDimName[row]

            var text = ""
            for (i, e) in chooseDims.chooseDim.enumerated() {
                text.append(e)
                if i <  chooseDims.chooseDim.count-1 {
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
        reChoose.isReport = true
        if let query = db {
            let chooseDims = query.chooseDimName[indexPath.row]
            for (_, e) in chooseDims.chooseDim.enumerated() {
                reChoose.strArray.append(e)
            }
        }
        self.navigationController?.pushViewController(reChoose, animated: true)
    }

}
