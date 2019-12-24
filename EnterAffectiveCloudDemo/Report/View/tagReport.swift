//
//  tagReport.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/12/11.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit
import SnapKit

class TagReport: UIView , UITableViewDelegate, UITableViewDataSource{
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let tableView = UITableView()
    let btn = UIButton()
    var query:DBTagSave?
    
    init(st: String) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .white
        self.layer.cornerRadius  =  8
        self.layer.masksToBounds = true
        query = TagRepository.findSt(st)
        
        
        titleLabel.text = "数据片段和标签"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .systemBlue
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        self.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.right.equalTo(-16)
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-42)
        }
        
        btn.setTitle("查看全部", for: .normal)
        self.addSubview(btn)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.bottom.equalToSuperview().offset(-16)
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let query = query {
            return query.chooseDimName.count >= 4 ? 4 : query.chooseDimName.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let identifier = "com.enter.report.identifier.r\(index).s\(indexPath.section)"
        let cell: UITableViewCell
        
        if let reuseView = tableView.dequeueReusableCell(withIdentifier: identifier) {
            cell = reuseView
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        cell.accessoryType = .disclosureIndicator
        if let query = query {
            let fromTime = query.time[row*2]
            let toTime = query.time[row*2+1]
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
        if let query = query {
            let chooseDims = query.chooseDimName[indexPath.row]
            for (_, e) in chooseDims.chooseDim.enumerated() {
                reChoose.strArray.append(e)
            }
        }
        UIViewController.currentViewController()!.navigationController?.pushViewController(reChoose, animated: true)
    }
    
    
}
