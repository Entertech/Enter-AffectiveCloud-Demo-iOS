//
//  DashboardIndexView.swift
//  EnterAffectiveCloudDemo
//
//  Created by Enter on 2019/11/14.
//  Copyright © 2019 Enter. All rights reserved.
//

import UIKit

enum DashboardType: String {
    case heart = "心率"
    case brainwave = "脑电波"
    case emotion = "情绪"
}

class DashboardIndexView: UIView, UITableViewDelegate, UITableViewDataSource {
 
    private let dashboardIndexKey = "DashboardIndex"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initTableView()
    }
    
    private func initTableView() {
        self.backgroundColor = UIColor.white
        let titleLabel = UILabel(frame: CGRect(x: 16, y: 8, width: 243, height: 21))
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.text = "拖动来改变数据面板顺序"
        titleLabel.textColor = UIColor.gray
        self.addSubview(titleLabel)
        
        let tableView = UITableView(frame: self.bounds, style: .plain)
        tableView.backgroundColor = UIColor.white;
        self.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.isEditing = true
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        titleLabel.snp.makeConstraints{
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(8)
            $0.width.equalTo(243)
            $0.height.equalTo(21)
            
        }
        
        tableView.snp.makeConstraints{
            $0.left.equalToSuperview().offset(0)
            $0.right.equalToSuperview().offset(-16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.height.equalTo(150)
        }
        
    }
    
    private let defaultDashboardIndex: [DashboardType] = [.heart, .brainwave, .emotion]
    var dashboardIndex: [DashboardType] {
        get {
            let value = UserDefaults.standard.array(forKey: dashboardIndexKey) as? [String]
            if value != nil {
                var array: [DashboardType] = []
                for e in value! {
                    if e == "心率" {
                        array.append(.heart)
                    } else if e == "脑电波" {
                        array.append(.brainwave)
                    } else if e == "情绪" {
                        array.append(.emotion)
                    }
                }
                return array
            } else {
                return defaultDashboardIndex
            }
        }
        
        set {
            var array: [String] = []
            for e in newValue {
                switch e {
                case .heart:
                    array.append("心率")
                case .brainwave:
                    array.append("脑电波")
                case .emotion:
                    array.append("情绪")
                }
            }
            UserDefaults.standard.set(array, forKey: dashboardIndexKey)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentify = "dashboardCell"
        var cell: TitleTableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentify)  as? TitleTableViewCell
        if cell == nil {
            cell = TitleTableViewCell(style: .default, reuseIdentifier: cellIdentify)
        }
        cell?.titleLabel?.text = dashboardIndex[indexPath.row].rawValue
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //exchangeValue(&dashboardIndex, sourceIndexPath.row, destinationIndexPath.row)
        insertValue(&dashboardIndex, sourceIndexPath.row, destinationIndexPath.row)
    }
    
    
    func exchangeValue<T>(_ nums: inout [T], _ a: Int, _ b: Int) {
        (nums[a], nums[b]) = (nums[b], nums[a])
    }
    
    func insertValue<T>(_ nums: inout[T], _ a: Int, _ b: Int) {
        let value = nums[a]
        nums.remove(at: a)
        nums.insert(value, at: b)
    }
    
}
